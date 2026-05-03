module Test where

import Evaluator

test_cases =
  [ -- Basic Addition and Subtraction
    ("5+10", 15),
    ("20-8", 12),
    ("1-1-1", -1),
    -- Multiplication and Division
    ("4*5", 20),
    ("20/4", 5),
    ("10/3", 3), -- Integer division check

    -- Precedence (MDAS)
    ("2+3*4", 14),
    ("10-4/2", 8),
    ("2*3+4*5", 26),
    -- Negative Numbers (Prefix Minus)
    ("-5", -5),
    ("-5+10", 5),
    ("10+-5", 5),
    ("-5*-2", 10),
    -- Nested Parentheses
    ("(2+3)*4", 20),
    ("10/(2+3)", 2),
    ("-(5+5)", -10),
    ("2*(3+(4-2))", 10),
    -- Function calls
    ("SQRT(64)", 8),
    ("10-SQRT(9)", 7),
    -- Complex Mixed Cases
    ("10--5", 15),
    ("-5- -5", 0),
    ("100/(10*2)-3", 2),
    ("-(10+5)*-2", 30)
  ]

runTests :: IO ()
runTests = mapM_ performTest test_cases
  where
    performTest (input, expected) =
      let result = run input
       in if result == EvalNum expected
            then putStrLn $ "PASS: " ++ input ++ " = " ++ show result
            else putStrLn $ "FAIL: " ++ input ++ " (Expected " ++ show expected ++ ", got " ++ show result ++ ")"
