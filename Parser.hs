module Parser where

import Data.Binary.Get (remaining)
import Lexer
import Data.Bifunctor (second)

parse :: [Token] -> Either String Expr
-- use fst function to remove empty list of tokens after parsing finishes
parse tokens = second fst(parseExpr 0 tokens)

data Expr
  = IntExpr Int
  | BinExpr Expr Operator Expr
  | FuncExpr String [Expr] -- function name & arguments
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

-- null denotation
nud :: Token -> [Token] -> (Expr, [Token])
nud (Num n) rest = (IntExpr n, rest)
nud LParen rest =
  let Right (innerExpr, afterInner) = parseExpr (getBP LParen) rest
   in case afterInner of
        (RParen : remaining) -> (ParenExpr innerExpr, remaining)
        _ -> error $ "Unclosed parenthesis" ++ show afterInner ++ " vs. " ++ show innerExpr
nud (Op Sub) rest =
  -- case: '-' as prefix -> high binding power
  -- use Mul as binding power -> "-x*5" binds as (-x)*5
  let Right (expr, remaining) = parseExpr (getBPOp Mul) rest
   in -- in (BinExpr (IntExpr (-1)) Mul expr, remaining)
      (BinExpr (IntExpr (-1)) Mul expr, remaining)
nud (Func fname) rest = 
  let Right (pExpr, afterExpr) = parseExpr (getBP LParen) rest
  in case pExpr of 
    ParenExpr p -> (FuncExpr fname [pExpr], afterExpr)
    _ -> error "Invalid function expression"

nud t _ = error $ "Unknown function name" ++ show t

-- left denotation
led :: Expr -> Token -> [Token] -> (Expr, [Token])
led left (Op op) rest =
  let Right (right, remaining) = parseExpr (getBPOp op) rest
   in (BinExpr left op right, remaining)

parseExpr :: Int -> [Token] -> Either String (Expr, [Token])
parseExpr _ [] = Left "Empty input"
parseExpr _ [Func s] = Left $ "Simple function'"++s++"', call it with ()"
parseExpr _ [Func s, LParen, RParen] = Right (FuncExpr s [], [])
parseExpr minBP (t : ts) =
  let (left, rest) = nud t ts
   in Right (parseExprInner minBP left rest)

parseExprInner :: Int -> Expr -> [Token] -> (Expr, [Token])
parseExprInner minBP left [] = (left, [])
parseExprInner minBP left (t : ts)
  -- add next token to left expression
  | getBP t > minBP =
      let (newLeft, newRest) = led left t ts
       in parseExprInner minBP newLeft newRest
  | t == RParen = (left, t : ts)
  -- normal case
  | otherwise = (left, t : ts)
