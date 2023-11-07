{-# LANGUAGE LambdaCase                  #-}
{-# LANGUAGE TemplateHaskell             #-}
{-# LANGUAGE ScopedTypeVariables         #-}
{-# LANGUAGE UnicodeSyntax               #-}
{-# LANGUAGE TypeApplications            #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE GADTs                       #-}

module SanityCheckTools where

import GradingRecord

import Prelude hiding (print, putStrLn, error)
import qualified Prelude
import Terminal.Indentation ( IndentedIO, error, print, putStrLn, warning
                            , runIndented, indent )
import Codec.Archive.Tar
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import System.Environment (getArgs)
import System.IO.Temp
import System.Exit
import System.Process
import System.Timeout
import qualified System.Process.ByteString as B
import System.FilePath
import System.Directory ( makeAbsolute, removeFile, doesFileExist
                        , doesDirectoryExist, createDirectoryIfMissing
                        , setOwnerExecutable )
import qualified Data.Yaml as Yaml
import qualified Data.Yaml.Pretty as Yaml
import System.Random
import UnliftIO.Directory ( withCurrentDirectory, removeDirectoryRecursive
                          , getPermissions, setPermissions )
import UnliftIO.Exception (catch, handleIO)
import qualified Data.Map as Map
import Data.Map (Map)
import qualified Data.Set as Set
import qualified Data.Binary as Bin
import qualified Data.Binary.Builder as Bin
import Data.Set (Set, isSubsetOf)
import Data.List (isSuffixOf)
import Control.Monad
import Control.Monad.IO.Class
import Control.Exception (IOException)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.Text.IO as T
import Data.FileEmbed (embedStringFile)
import Text.Regex.TDFA
import Text.Printf
import Text.Read (readMaybe)
import Numeric (showHex)
import qualified Data.Char as Char
import Data.Char.Properties.Names (getCharacterName)

import Debug.Trace (trace)

checkArchiveFile :: Assessment a
   => [String]         -- ^ Regex patterns that the file name may match
   -> FileCheckers a   -- ^ The checks to run on contained files
   -> Bool             -- ^ Whether directory entries are allowed
   -> Bool             -- ^ Whether it's ok to have everything in a global subdirectory
   -> Maybe FilePath   -- ^ Master grading dir. If none, use directory where the archive resides.
   -> Bool             -- ^ Whether grading dir should be visible
   -> FilePath         -- ^ Archive file
   -> IndentedIO ()
checkArchiveFile validArchNames fileCheckers dirsAllowed globalPrefixAllowed
           masterGD visibleGD archiveFp = do
  when ( not $ any (takeFileName archiveFp =~) validArchNames )
    . putStrLn $ "Filename should match either of "++show validArchNames
  putStrLn $ "Opening ‘"++archiveFp++"’..."
  conts <- unarchive <$> liftIO (B.readFile archiveFp)
  indent 2 $ case conts of
     Left msg -> error $ "This does not seem to be an archive built with the `tar cf` command.\n" ++ msg
     Right arch -> do
        gradingDir <- case masterGD of
          Nothing
           | visibleGD -> do
            liftIO . makeAbsolute
              $ takeDirectory archiveFp</>"."<>takeBaseName archiveFp<>".grading"
           | otherwise -> do
            liftIO . makeAbsolute $ dropExtension archiveFp<>".grading"
          Just mgd -> liftIO . makeAbsolute
                $ dropExtension (mgd</>takeFileName archiveFp)<>".grading"
        when visibleGD . putStrLn $ "Grading in directory "++gradingDir
        checkArchiveContents fileCheckers dirsAllowed globalPrefixAllowed arch gradingDir
        when (not visibleGD) $ removeDirectoryRecursive gradingDir

type LocForIO a = (IndentedIO a -> IndentedIO a)

checkArchiveContents :: ∀ a . Assessment a
   => FileCheckers a -- ^ The checks to run on contained files
   -> Bool           -- ^ Whether directory entries are allowed
   -> Bool           -- ^ Whether it's ok to have everything in a global subdirectory
   -> Archive        -- ^ Original content to grade
   -> FilePath       -- ^ Directory name for grading files
   -> IndentedIO ()
checkArchiveContents fileCheckers dirsAllowed globalPrefixAllowed arch gradingDirName = do
  let desiredFiles = Map.keysSet fileCheckers
      necessaryFiles = Map.keysSet
           $ Map.filter (\case {(Obligatory,_)->True; _->False}) fileCheckers
      actualFiles = Map.keysSet arch
  (actualFiles', prefixStrip) <- indent 5 $ do
    let thisDirStripped = Set.map stripThisDir $ Map.keysSet arch
    ps <- commonDirStripping globalPrefixAllowed thisDirStripped
    return (Set.map ps thisDirStripped, ps . stripThisDir)
  putStrLn "Archive contains the following entries:" 
  indent 2 $ do
    print $ Set.toList actualFiles
    case filter ('/'`elem`) $ Set.toList actualFiles' of
     [] -> pure ()
     dirF:_
      | dirsAllowed -> pure ()
      | otherwise -> error $ "File ‘"++dirF++"’ is in a subdirectory."
                               ++" The archive should have a flat structure."
    case Set.toList $ (necessaryFiles`Set.difference`Set.filter (not . null) actualFiles')
      of (missingFile:_) -> error
          $ "File “"++missingFile++"” is missing in archive."
         _ -> pure ()
    case Set.toList $ (Set.filter (not . null) actualFiles'`Set.difference`desiredFiles)
      of (missingFile:_) -> warning
          $ "File “"++missingFile++"” should not be in archive."
         _ -> pure ()
  let inGradingDir :: LocForIO x
      inGradingDir fAction = do
        liftIO $ createDirectoryIfMissing False gradingDirName
        withCurrentDirectory gradingDirName fAction
  forM_ (Map.toList arch) $ \(f, entry) -> case entry of
    RegularFileMember fc
     | Just (_, checker) <- fileCheckers Map.!? prefixStrip f -> do
      putStrLn $ "Checking ‘"++f++"’..."
      indent 2 $ do
        let gradesFileName = "grades.yaml"
        origGrades <- inGradingDir . liftIO $ doesFileExist gradesFileName >>= \ex -> 
             if ex then assessmentJSONable @a @Maybe
                         (Yaml.decodeFileThrow gradesFileName)
                   else pure emptyAssessment
        taskResult <- checker inGradingDir origGrades . T.decodeUtf8 $ regContents fc
        inGradingDir . liftIO $ do
           B.writeFile gradesFileName
               . assessmentJSONable @a @Maybe
                    (Yaml.encodePretty (Yaml.setConfCompare compare Yaml.defConfig))
               $ taskResult
        return ()
     | otherwise -> do
         warning
          $ "File “"++f++"” should not be in archive."
    DirectoryMember _ | null $ prefixStrip f
        -> pure ()
    _ -> do
      if dirsAllowed then pure ()
                     else error $ "Entry ‘"++f++"’ is not a regular file."

stripThisDir :: FilePath -> FilePath
stripThisDir ('.':'/':fp) = stripThisDir fp
stripThisDir fp = fp

commonDirStripping :: Bool -> Set FilePath -> IndentedIO (FilePath -> FilePath)
commonDirStripping prefixAllowed fs = case map (span (/='/')) $ Set.toList fs of
   l@((pref, '/':_) : _)
      | all (\case (p,'/':_) -> p==pref
                   _         -> False ) l
        -> if prefixAllowed
            then do
              putStrLn ("Found common prefix "++pref)
              return (drop $ length pref + 1)
            else
              error $ "The archive contains everything in subdirectory ‘"++pref++"’. It should contain the files directly instead."
   _ -> return id

data Necessity = Obligatory | Optional


genRandMatrixData :: Int -> Int -> IO Bin.Builder
genRandMatrixData n m = mconcat <$> replicateM (n*m)
      (Bin.putInt32le <$> randomRIO (0,12))

type FileCheckers a = Map FilePath
                 (Necessity, LocForIO () -> a Maybe
                           -> Text -> IndentedIO (a Maybe))

data EnsurableEncoding = RequirePrintableUnicode
                       | RequirePrintableASCII_TfmNorwegian
                       | EnforcePrintableASCII

ensureEncoding :: EnsurableEncoding -> Text -> IndentedIO Text
ensureEncoding enc code = fmap (T.concat . map T.pack)
                            . forM (T.unpack code) $ \case
  '\r' -> pure ""
  c | isRightStandard c && (Char.isPrint c || Char.isSpace c)
       -> pure [c]
  _ | RequirePrintableUnicode <- enc
          -> error "File should contain only printable Unicode."
  'æ' -> pure "ae"
  'ø' -> pure "oe"
  'å' -> pure "aa"
  'Æ' -> pure "Ae"
  'Ø' -> pure "Oe"
  'Å' -> pure "Aa"
  _ | EnforcePrintableASCII <- enc
         -> pure "#"
  _ | RequirePrintableASCII_TfmNorwegian <- enc
          -> error "File should only contain ASCII."
 where isRightStandard = case enc of
         RequirePrintableUnicode -> const True
         EnforcePrintableASCII -> Char.isAscii
         RequirePrintableASCII_TfmNorwegian -> Char.isAscii

ensureSensibleLineCount :: Int -> Int -> Int -> Text -> IndentedIO ()
ensureSensibleLineCount lMin lPlausible lMax code
  | lslen > lMax
       = error $ "File is too long ("++show lslen++" lines), should be at most "
                                     ++show lMax++"."
  | lslen > lPlausible
       = putStrLn $ "Warning: file is very long ("++show lslen++" lines)."
                  ++" A reasonable solution should be at most "++show lPlausible++"."
                  ++"\nUnless you have a very good reason for such a long submission, this may result in a reject,"
                  ++"\nbecause an excessively large assembly source file can hardly be checked for correctness."
  | lslen < lMin
       = error $ "File is too short ("++show lslen++" lines), should be at least "
                                      ++show lMin++"."
  | (lLong:_) <- filter ((>llmax) . T.length) ls
       = error $ "File contains over-long line ("++show (T.length lLong)++" characters)"
                ++ "\n  “"++take 60 (T.unpack lLong)++".......”"
                ++ "\nPlease limit your lines to ca. 140 characters."
                ++ "\n(Style conventions in software business put the limit to rather like 96 characters.)"
  | otherwise
       = return ()
 where ls = T.lines code
       lslen = length ls
       llmax = 220

data CommentishLanguage = CommentedBash | CommentedAssembly

ensureSensibleCommentCount :: CommentishLanguage -> Int -> Int -> Text -> IndentedIO ()
ensureSensibleCommentCount lang nMin nMax code
  | nComments > nMax
       = error $ "File has too many comments ("++show nComments++" comments), should be at most "
                                     ++show nMax++"."
  | nComments < nMin
       = error $ "Has too few substantial comments ("++show nComments++" commented lines), should be at least "
                                      ++show nMin++"."
  | otherwise
       = return ()
 where ls = T.lines code
       commentedLines = filter
            (\l -> length l > 9
                && ( head l==commentToken
                    || length (dropWhile (\(c,c') -> c'/=commentToken||c=='$')
                              (zip l $ tail l)) > 9 ))
             $ T.unpack <$> ls
       commentToken = case lang of
          CommentedBash -> '#'
          CommentedAssembly -> ';'
       nComments = length commentedLines

ensureBashShebang :: Text -> IndentedIO ()
ensureBashShebang code = case T.lines code of
   ("#!/bin/bash":_) -> pure ()
   ("#!/usr/bin/env bash":_) -> pure ()
   (firstline:_) -> error $ "File should be an executable Bash script. The first line should only include the shebang."
                           ++ "\nInstead, first line is "++show firstline
   [] -> error $ "This file ("++show (T.length code)++" characters) does not have any lines."
                  ++ "\nYou should submit the script as a regular ASCII text file with UNIX line endings."

ensureIsSubroutine :: String -> Text -> IndentedIO ()
ensureIsSubroutine subroutineName = go . T.lines
 where go [] = error $ "Subroutine ‘"++subroutineName++"’ not contained in file."
       go (l:ls)
        | T.take (length subroutineName+1) l == T.pack (subroutineName++":")
                     = putStrLn $ "Found subroutine ‘"++subroutineName++"’."
        | stripped <- T.dropWhile (==' ') l
        , T.null stripped || T.take 1 stripped == T.pack ";"
                     = go ls
        | otherwise  = error $ "Found non-comment line\n"
                        ++ "  “"++T.unpack l++"”"
                        ++ "\nFile should contain the full subroutine ‘"++subroutineName
                                ++"’, and nothing else."

tryRunnableBashScripts :: LocForIO () -> String -> Map String Text
                -> (Map String FilePath -> IndentedIO (a->a)) -> IndentedIO (a->a)
tryRunnableBashScripts inGradingDir nameTplt srcFiles executableChecker
  = withSystemTempDirectory (nameTplt++"-scriptrun") $ \dir -> do
     let progSrcFn fn = (fn++"Test")<.>"sh"
         writeTestBashFile fn code = liftIO . T.writeFile fn $ code
         writeAllBashFiles = forM_ (Map.toList srcFiles)
                           . uncurry $ writeTestBashFile . progSrcFn
     inGradingDir writeAllBashFiles
     withCurrentDirectory dir $ do
         execs <- handleIO (const $ pure Map.empty)
           $ Map.fromList <$> forM (Map.toList srcFiles)`id`\(fnTp, code) -> do
            let execName = progSrcFn fnTp
            writeTestBashFile execName code
            perms <- getPermissions execName
            setPermissions execName $ setOwnerExecutable True perms
            return (fnTp, execName)
         executableChecker execs

tryCompileAndUse :: LocForIO () -> String -> Map String Text
                -> (Map String FilePath -> IndentedIO (a->a)) -> IndentedIO (a->a)
tryCompileAndUse inGradingDir nameTplt srcFiles executableChecker
  = withSystemTempDirectory (nameTplt++"-compilation") $ \dir -> do
     let progSrcFn fn = (fn++"Test")<.>"asm"
         writeTestAssemblyFile fn code = liftIO . T.writeFile fn $ code
         writeAllAssemblyFiles = forM_ (Map.toList srcFiles)
                           . uncurry $ writeTestAssemblyFile . progSrcFn
     inGradingDir writeAllAssemblyFiles
     r <- withCurrentDirectory dir $ do
       -- First compiling a hello world, to ensure compiler etc. is working
       liftIO . T.writeFile "hello.asm" $ $(embedStringFile "asm-template/hello.asm")
       let setupProblemMessage
             = "\nThere seems to be something wrong with your"
               ++" compilation environment (nasm/ld)."
       helloSuccess <- nasmCompilation "hello.asm"
        (\compile -> catch (liftIO $ Just<$>compile)
                            $ \(_ :: IOException) -> do
                        putStrLn $ "Unable to compile hello world test program."
                                   ++ setupProblemMessage
                        pure Nothing)
             $ \case
        Just exec -> do
          hello <- liftIO . catch (readProcess exec [] "")
                     $ \(_ :: IOException) -> pure ""
          case lines hello of
           [] -> do
             putStrLn $ "Unable to run hello world test program."++setupProblemMessage
             return False
           ["Hello World!"] -> return True
           [bogus] -> do
             putStrLn
              $ "Hello world test program yielded output “"
                  ++ bogus ++ "”"
                  ++setupProblemMessage
             return False
           _ -> do
             putStrLn
              $ "Hello world test program yielded multiple output lines."
                  ++setupProblemMessage
             return False
        Nothing -> return False
             
       if not helloSuccess
        then do
         putStrLn "Skipping compilation test"
         return id
        else putStrLn "Compiling...">>indent 2 `id` do
         execs <- handleIO (const $ pure Map.empty)
           $ Map.fromList <$> forM (Map.toList srcFiles)`id`\(fnTp, code) -> do
            writeTestAssemblyFile (progSrcFn fnTp) code
            exec <- nasmCompilation (progSrcFn fnTp) liftIO pure
            putStrLn $ "Compiled "++show exec
            return (fnTp, exec)
         when (not $ Map.null execs) $ putStrLn "This seems to compile ok."
         executableChecker execs
     -- inGradingDir . liftIO $ removeFile progSrcFn
     return r
         

nasmCompilation :: Monad m
                  => FilePath
                  -> (IO FilePath -> m fn)
                  -> (fn -> m r)
                  -> m r
nasmCompilation src compileEnv executableChecker = do
   execN <- compileEnv $ do
      callProcess "nasm" ["-f", "elf", "-F", "dwarf", "-g", src]
      let execName = dropExtension src
      callProcess "ld" ["-m", "elf_i386", "-o", execName, src-<.>"o"]
      makeAbsolute execName
   executableChecker execN


inlineAssemblyIncludes :: Map String Text -> Text -> Text
inlineAssemblyIncludes replaces code = T.unlines $ T.lines code >>= \l
   -> case T.unpack l =~ ("^%include \"([^\"]*)\" *(;.*)?$" :: String)
               :: (String,String,String,[String]) of
       ("", _, "", inclName:_) -> case replaces Map.!?
                                         if ".asm"`isSuffixOf`inclName
                                          then take (length inclName - 4) inclName
                                          else inclName of
         Just inclCode -> T.lines inclCode
         Nothing -> Prelude.error $ "Trying to include file “"++inclName
                                     ++"”. Supported are "++show(fst<$>Map.toList replaces)
       _ -> [l]
       
