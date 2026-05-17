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
executeCmd HELP = putStrLn "I am trying to help you"
executeCmd CLEAR = clearScreen

clearScreen :: IO ()
clearScreen = putStr "\ESC[2J\ESC[1;1H"
