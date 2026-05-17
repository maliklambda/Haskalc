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
  putStrLn $ "Lexer result: " ++ show (lexer input)
  putStrLn $ "Parser result: " ++ show (parse (lexer input))
  let result = run input
  case result of 
    EvalCmd cmd -> putStrLn $ "Executing command: " ++ show cmd
    EvalNum n -> putStrLn $ "Result (numeric): " ++ show n
    EvalBool b -> putStrLn $ "Result (boolean): " ++ show b
    EvalError err -> putStrLn $ "Error: " ++ err
  if input == "exit" then return () else loop prompt args
