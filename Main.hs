module Main where

import Control.Monad.State (MonadIO (liftIO), execState)
import Data.Char (isDigit, isSpace)
import Evaluator
import GHC.IO.FD (stdout)
import GHC.IO.Handle (hFlush)
import Lexer
import Parser
import System.Environment
import Test
import System.IO

main :: IO ()
main = do
  hSetBuffering stdin LineBuffering
  args <- getArgs
  -- if args.first == "--test": runTests
  loop "> " []
  print "Bye."

loop :: String -> [String] -> IO ()
loop prompt args = do
  putStr prompt
  input <- getLine
  putStrLn $ "result: " ++ show (run input)
  if input == "exit" then return () else loop prompt args
