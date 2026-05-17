module Main where

import Command (CMD, executeCmd)
import Control.Monad.State (MonadIO (liftIO), execState)
import Evaluator
import Lexer
import Parser
import System.Environment
import System.IO
import Test

main :: IO ()
main = do
  hSetBuffering stdin LineBuffering
  hSetBuffering stdout NoBuffering
  args <- getArgs
  -- if args.first == "--test": runTests
  loop "> " [] []

loop :: String -> [String] -> [String] -> IO ()
loop prompt args inputs = do
  putStr prompt
  -- TODO: allow user to press arrow up/down to go to last cmds
  input <- getLine
  putStrLn $ "Lexer result: " ++ show (lexer input)
  putStrLn $ "Parser result: " ++ show (parse (lexer input))
  let result = run input
  case result of
    EvalCmd cmd -> executeCmd cmd
    EvalNum n -> putStrLn $ "Result (numeric): " ++ show n
    EvalBool b -> putStrLn $ "Result (boolean): " ++ show b
    EvalError err -> putStrLn $ "Error: " ++ err
  loop prompt args (inputs ++ [input])
