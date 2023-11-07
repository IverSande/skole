module Terminal.Indentation where

import Prelude hiding (putStrLn, print)
import qualified Prelude

import Control.Monad.Trans.Reader
import Control.Monad.IO.Class
import Control.Monad (forM_)
import System.Exit (exitFailure)

type IndentedIO = ReaderT Int IO

runIndented :: IndentedIO a -> IO a
runIndented a = runReaderT a 0

indent :: Int -> IndentedIO a -> IndentedIO a
indent i = local (+i)

putStrLn :: String -> IndentedIO ()
putStrLn = ReaderT . pslIndented
 where pslIndented "" i = Prelude.putStrLn ""
       pslIndented s i = forM_ (lines s) $ \l -> Prelude.putStrLn $ replicate i ' '++l

print :: Show a => a -> IndentedIO ()
print = putStrLn . show

warning :: String -> IndentedIO ()
warning msg = do
  putStrLn "WARNING"
  indent 2 $ putStrLn msg

error :: String -> IndentedIO a
error msg = do
  putStrLn "ERROR"
  indent 2 $ putStrLn msg
  liftIO exitFailure

