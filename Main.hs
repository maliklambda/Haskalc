module Main where

import Data.Char (isDigit, isSpace)
import Evaluator
import Lexer
import Parser
import System.Environment
import Test

main :: IO ()
main = do
  -- args <- getArgs
  -- -- if args[0] == "--test" -> runTests
  -- -- else: start repl
  -- print args
  runTests

  let input = "2*(9)"
  print $ "input: '" ++ input ++ "'"
  let tokens = lexer input
  print $ "Lexer output: " ++ show tokens
  let parsed = parse tokens
  print $ "Parser output: " ++ show parsed
  let result = eval parsed
  print $ "Parser output: " ++ show result

