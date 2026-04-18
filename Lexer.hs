module Lexer where

import Data.Char (isDigit, isSpace)

data Token
  = Num Int
  | Op Operator
  | RParen
  | LParen
  deriving (Eq, Show)

data Operator 
  = Add 
  | Mul 
  | Sub -- Lexer stays "dumb" and parser handles negative expressions
  | Div 
  deriving (Eq, Show)

lexer :: String -> [Token]
lexer [] = []
lexer ('+' : cs) = Op Add : lexer cs
lexer ('*' : cs) = Op Mul : lexer cs
lexer ('/' : cs) = Op Div : lexer cs
lexer ('(' : cs) = LParen : lexer cs
lexer (')' : cs) = RParen : lexer cs
lexer ('-' : cs) = Op Sub : lexer cs
lexer (c : cs)
  | isSpace c = lexer cs
  | isDigit c =
      let (digits, rest) = span isDigit (c : cs)
      in Num (read digits) : lexer rest
lexer (_ : cs) = error "Invalid Character"

-- Parses multidigit (positive) number to one integer
nextNum :: Char -> String -> (Int, String)
nextNum c cs =
      let (digits, rest) = span isDigit (c : cs)
      in (read digits, cs)
