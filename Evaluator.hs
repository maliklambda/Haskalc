module Evaluator where

import Lexer
import Parser


-- run combines all steps to compute the result
run :: String -> Int
run s = eval (parse (lexer s))

eval :: Expr -> Int
eval (IntExpr n) = n
eval (ParenExpr p) = eval p
eval (BinExpr lhs op rhs)
  | op == Add = eval lhs + eval rhs
  | op == Sub = eval lhs - eval rhs
  | op == Mul = eval lhs * eval rhs
  | op == Div = eval lhs `div` eval rhs -- cut fraction of result
