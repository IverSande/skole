{-# LANGUAGE LambdaCase                  #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE ScopedTypeVariables         #-}
{-# LANGUAGE StandaloneDeriving          #-}
{-# LANGUAGE FlexibleContexts            #-}
{-# LANGUAGE UndecidableInstances        #-}
{-# LANGUAGE ViewPatterns                #-}
{-# LANGUAGE GADTs                       #-}
{-# LANGUAGE TemplateHaskell             #-}

module Main where

import GradingRecord
import SanityCheckTools

import Prelude hiding (print, putStrLn, error)
import qualified Prelude
import Terminal.Indentation (IndentedIO, error, print, putStrLn, runIndented, indent)
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
                        , doesDirectoryExist, createDirectoryIfMissing )
import qualified Data.Yaml as Yaml
import qualified Data.Yaml.Pretty as Yaml
import System.Random
import UnliftIO.Directory (withCurrentDirectory, listDirectory, renamePath)
import UnliftIO.Exception (catch, handleIO)
import qualified Data.Map as Map
import Data.Map (Map)
import qualified Data.Set as Set
import qualified Data.Binary as Bin
import qualified Data.Binary.Builder as Bin
import Data.Set (Set, isSubsetOf)
import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Exception (IOException)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.Text.IO as T
import Data.FileEmbed (embedStringFile)
import Text.Regex.TDFA
import qualified Data.Aeson as Json
import Data.Aeson (FromJSON, parseJSON, ToJSON, toJSON)
import Text.Printf
import Text.Read (readMaybe)
import Numeric (showHex)
import qualified Data.Char as Char
import Data.Char.Properties.Names (getCharacterName)

import Debug.Trace (trace)


fileCheckers :: Map FilePath
                 (Necessity, LocForIO () -> A2_Assessment Maybe
                           -> Text -> IndentedIO (A2_Assessment Maybe))
fileCheckers = Map.fromList $
  [ ( "task0-1.png"
    , ( Obligatory, \_ _ _ -> pure emptyAssessment )
    )
  , ( "task0-2.png"
    , ( Obligatory, \_ _ _ -> pure emptyAssessment )
    )
  , ( "task0-3.png"
    , ( Optional, \_ _ _ -> pure emptyAssessment )
    )
  , ( "printsum.asm"
    , ( Obligatory, codeCheck $ \inGradingDir code -> do
       let tpn = "printsum"
       ensureSensibleLineCount 100 200 300 code
       ensureSensibleCommentCount CommentedAssembly 20 200 code
       functionalityGrading <- tryCompileAndUse inGradingDir tpn
         (Map.fromList [( tpn, code )
                       ])
         (\(Map.toList -> [(_,printsumLL)]) -> do
           compose <$> forM [(4,7), (5,8), (6,2)] `id` \(n₀,n₁ :: Int) -> do
             putStrLn $ printf "Trying %i %i..." n₀ n₁
             liftIO `id` readProcessWithExitCode printsumLL []
                         (printf "%i %i\n" n₀ n₁) >>= \case
               (ExitFailure i, _, _)
                   -> error $ "Program fails with exit code "<>show i
               (ExitSuccess, progOutput, "")
                | resultline <- last $ lines progOutput
                , readMaybe (take 2 resultline) == Just (n₀+n₁)
                      && drop 2 resultline `elem` ["","\r","\r\n"] -> do
                    putStrLn $ printf "Program correctly gives back sum %i + %i = %s."
                                                                      n₀ n₁ resultline
                    return id
                | otherwise -> error
                        $ "Program does not yield sum"
                          <>printf "\n  (“%i %i” ⟼ %s)."
                               n₀ n₁ progOutput
          )
       return id
      )
    )
  , ( "task1.pdf"
    , ( Obligatory, \_ _ _ -> pure emptyAssessment )
    )
  ]
 where codeCheck :: (LocForIO () -> Text
            -> IndentedIO (A2_Assessment Maybe -> A2_Assessment Maybe))
        -> LocForIO () -> A2_Assessment Maybe
             -> Text -> IndentedIO (A2_Assessment Maybe)
       codeCheck f inGradingDir origGrading code' = do
          code <- ensureEncoding RequirePrintableASCII_TfmNorwegian code'
          ($ origGrading) <$> f inGradingDir code


main :: IO ()
main = do
   args <- getArgs
   let validArchNames = ["oblig2-[0-9]+.tar$", "oblig2-group[0-9]+.tar$"]
       dirsAllowed = True
       globalPrefixAllowed = True
       archCheck = checkArchiveFile validArchNames
                      fileCheckers dirsAllowed globalPrefixAllowed
   case filter (not . (`elem`["--help", "-h"])) args of
    [archiveFp] -> runIndented
         $ archCheck Nothing False archiveFp
    [archiveFp, masterGD] -> do
       masterIsDirectory <- doesDirectoryExist masterGD
       runIndented $ if masterIsDirectory
        then archCheck (Just masterGD) True archiveFp
        else error $ "Second argument must be a directory (in which to perform the grading)."
    _ -> do
      Prelude.putStrLn "Use this checker with your submission ‘.tar’ archive as an argument."

data A2_Assessment p = Assessment
      { archivePenalty :: TaskGrade p Subgrade
      , globalComment :: Maybe T.Text
      }
deriving instance (Show (TaskGrade g Bool), Show (TaskGrade g Subgrade))
      => Show (A2_Assessment g)

instance (FromJSON (TaskGrade p Bool), FromJSON (TaskGrade p Subgrade))
              => FromJSON (A2_Assessment p) where
  parseJSON = Yaml.withObject "Assessment" $ \km ->
     Assessment <$> ((km Json..: "archive")
                      <|> pure (CommentedGrade (Subgrade 0) Nothing))
                <*> (Just<$>(km Json..: "comment")
                      <|> pure Nothing)
instance (ToJSON (TaskGrade p Bool), ToJSON (TaskGrade p Subgrade))
              => ToJSON (A2_Assessment p) where
  toJSON a = toJSON . Map.fromList
     $ ( case archivePenalty a of
          Ungraded -> []
          CommentedGrade (Subgrade 0) Nothing -> []
          apa -> [("archive", toJSON $ apa)] )
     ++ case globalComment a of
         Nothing -> []
         Just c -> [("comment" :: String, toJSON c)]

instance Assessment A2_Assessment where
  emptyAssessment
   = Assessment Ungraded Nothing
  brokenArchiveAssessment
   = Assessment (CommentedGrade (Subgrade (-1)) Nothing)
                      Nothing
  assessmentJSONable φ = φ

compose :: [a->a] -> a->a
compose [] = id
compose (f:fs) = f . compose fs
