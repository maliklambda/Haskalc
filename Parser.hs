module Parser where

import Data.Binary.Get (remaining)
import Lexer

parse :: [Token] -> Expr
-- use fst function to remove empty list of tokens after parsing finishes
parse tokens = fst (parseExpr 0 tokens)

data Expr
  = IntExpr Int
  | BinExpr Expr Operator Expr
  | ParenExpr Expr
  deriving (Show)

-- binding power
getBP :: Token -> Int
getBP (Op op) = getBPOp op
getBP _ = 0

getBPOp :: Operator -> Int
getBPOp op 
    | op == Add = 10
    | op == Sub = 10 -- only used for infix
    | op == Mul = 20
    | op == Div = 20

nud :: Token -> [Token] -> (Expr, [Token])
nud (Num n) rest = (IntExpr n, rest)
nud LParen rest =
  let (innerExpr, afterInner) = parseExpr (getBP LParen) rest
   in case afterInner of
        (RParen : remaining) -> (ParenExpr innerExpr, remaining)
        _ -> error $ "Unclosed parenthesis" ++ show afterInner ++ " vs. " ++ show innerExpr

nud (Op Sub) rest = -- case: '-' as prefix -> high binding power
  -- use Mul as binding power -> "-x*5" binds as (-x)*5
  let (expr, remaining) = parseExpr (getBPOp Mul) rest
  -- in (BinExpr (IntExpr (-1)) Mul expr, remaining)
  in (BinExpr (IntExpr (-1)) Mul expr, remaining)
  
nud t _ = error "Expression must start with a number, a '(' or a '-'"

led :: Expr -> Token -> [Token] -> (Expr, [Token])
led left (Op op) rest =
    let (right, remaining) = parseExpr (getBPOp op) rest
    in (BinExpr left op right, remaining)

parseExpr :: Int -> [Token] -> (Expr, [Token])
parseExpr _ [] = error "Empty input"
parseExpr minBP (t : ts) =
  let (left, rest) = nud t ts
   in parseExprInner minBP left rest

parseExprInner :: Int -> Expr -> [Token] -> (Expr, [Token])
parseExprInner minBP left [] = (left, [])
parseExprInner minBP left (t : ts)
  -- add next token to left expression
  | getBP t > minBP =
      let (newLeft, newRest) = led left t ts
       in parseExprInner minBP newLeft newRest
  | t == RParen = (left, t:ts)
  -- normal case
  | otherwise = (left, t:ts)
