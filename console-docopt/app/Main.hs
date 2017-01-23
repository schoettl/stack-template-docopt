{-# LANGUAGE QuasiQuotes #-}

module Main where

import Lib
import System.Console.Docopt
import System.Environment (getArgs)

-- for example:
import Control.Monad (when)
import Data.Char (toUpper)

-- Use docopt|...| instead of docoptFile|...|
-- if you prefer an inline usage message.
patterns :: Docopt
patterns = [docoptFile|USAGE.txt|]

getArgOrExit = getArgOrExitWith patterns

main :: IO ()
main = do
  args <- parseArgsOrExit patterns =<< getArgs

  when (args `isPresent` (command "cat")) $ do
    file <- args `getArgOrExit` (argument "file")
    putStr =<< readFile file

  when (args `isPresent` (command "echo")) $ do
    let charTransform = if args `isPresent` (longOption "caps")
                          then toUpper
                          else id
    string <- args `getArgOrExit` (argument "string")
    putStrLn $ map charTransform string
