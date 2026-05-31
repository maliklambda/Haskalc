module Command where

import System.Exit (exitSuccess)

data CMD
  = EXIT
  | HELP
  | CLEAR
  deriving (Show, Eq)

executeCmd :: CMD -> IO ()
executeCmd EXIT = do
  putStrLn "Good bye then."
  exitSuccess
executeCmd HELP = putStrLn $ "Built in commands are:\n"
  ++"\texit: exits the program\n\thelp: prints helpful info (you should already know this one)\n\tclear: Clears the backgorund\n" 
  ++"Commands are considered functions. Functions must be called with parenthesis: function_name().\n\n"
  ++ "Usage:\n"
  ++ "\tType in any arithmetic expression of your choice. The program will then parse and evaluate it.\n"
  ++ "\tHere are some examples:\n\t> 2*4\n\t> -45+(3/2)*2\n\t> SQRT(9)*10\n"
executeCmd CLEAR = clearScreen

clearScreen :: IO ()
clearScreen = putStr "\ESC[2J\ESC[1;1H"
