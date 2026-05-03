module Evaluator where

import Lexer
import Parser

-- run combines all steps to compute the result
run :: String -> EvalResult
run s = eval (parse (lexer s))

data EvalResult where
  -- EvalNum :: (Num a, Show a) => a -> EvalResult
  EvalNum :: Double -> EvalResult
  EvalBool :: Bool -> EvalResult
  deriving (Show, Eq)

eval :: Expr -> EvalResult
eval (IntExpr n) = EvalNum (fromIntegral n)
eval (ParenExpr p) = eval p
eval (FuncExpr fname args)
  | fname == "SQRT" = fnSQRT args
  | otherwise = error $ "Unsupported function: " ++ fname
-- Addition
eval (BinExpr lhs Add rhs) =
  case (eval lhs, eval rhs) of
    (EvalNum l, EvalNum r) -> EvalNum (fromRational (toRational (l + r)))
    _ -> error $ "Unsupported Add operation between " ++ show lhs ++ " and " ++ show rhs
-- Subtraction
eval (BinExpr lhs Sub rhs) =
  case (eval lhs, eval rhs) of
    (EvalNum l, EvalNum r) -> EvalNum (l - r)
    _ -> error $ "Unsupported Sub operation between " ++ show lhs ++ " and " ++ show rhs
-- Mulitplication
eval (BinExpr lhs Mul rhs) =
  case (eval lhs, eval rhs) of
    (EvalNum l, EvalNum r) -> EvalNum (l * r)
    _ -> error $ "Unsupported Mul operation between " ++ show lhs ++ " and " ++ show rhs
-- Division
eval (BinExpr lhs Div rhs) =
  case (eval lhs, eval rhs) of
    (EvalNum l, EvalNum r) -> EvalNum (l / r)
    _ -> error $ "Unsupported Div operation between " ++ show lhs ++ " and " ++ show rhs

fnSQRT :: [Expr] -> EvalResult
fnSQRT [ParenExpr (IntExpr val)] = EvalNum (sqrt (fromIntegral val))
fnSQRT _ = error "Invalid arguments for function SQRT"
