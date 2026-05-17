module Evaluator where

import Lexer
import Parser
import Command (CMD (EXIT, HELP, CLEAR))

-- run combines all steps to compute the result
run :: String -> EvalResult
run s = eval (parse (lexer s))

data EvalResult where
  -- EvalNum :: (Num a, Show a) => a -> EvalResult
  EvalNum :: Double -> EvalResult
  EvalBool :: Bool -> EvalResult
  EvalError :: String -> EvalResult
  EvalCmd :: CMD -> EvalResult
  deriving (Show, Eq)

eval :: Either String Expr -> EvalResult
eval (Left s) = EvalError s
eval (Right (IntExpr n)) = EvalNum (fromIntegral n)
eval (Right (ParenExpr p)) = eval (Right p)
eval (Right (FuncExpr fname args))
  | fname == "SQRT" = fnSQRT args
  | fname == "exit" = EvalCmd EXIT
  | fname == "help" = EvalCmd HELP
  | fname == "clear" = EvalCmd CLEAR
  | otherwise = EvalError $ "Unsupported function: " ++ fname
-- Addition
eval (Right( BinExpr lhs Add rhs)) =
  case (eval (Right lhs), eval (Right rhs)) of
    (EvalNum l, EvalNum r) -> EvalNum (fromRational (toRational (l + r)))
    _ -> error $ "Unsupported Add operation between " ++ show lhs ++ " and " ++ show rhs
-- Subtraction
eval (Right (BinExpr lhs Sub rhs)) =
  case (eval (Right lhs), eval (Right rhs)) of
    (EvalNum l, EvalNum r) -> EvalNum (l - r)
    _ -> error $ "Unsupported Sub operation between " ++ show lhs ++ " and " ++ show rhs
-- Mulitplication
eval (Right (BinExpr lhs Mul rhs)) =
  case (eval (Right lhs), eval (Right rhs)) of
    (EvalNum l, EvalNum r) -> EvalNum (l * r)
    _ -> error $ "Unsupported Mul operation between " ++ show lhs ++ " and " ++ show rhs
-- Division
eval (Right (BinExpr lhs Div rhs)) =
  case (eval (Right lhs), eval (Right rhs)) of
    (EvalNum l, EvalNum r) -> EvalNum (l / r)
    _ -> error $ "Unsupported Div operation between " ++ show lhs ++ " and " ++ show rhs

fnSQRT :: [Expr] -> EvalResult
fnSQRT [ParenExpr (IntExpr val)] = EvalNum (sqrt (fromIntegral val))
fnSQRT _ = EvalError "Invalid arguments for function SQRT"
