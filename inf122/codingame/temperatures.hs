
import System.IO
import Control.Monad
import Data.List
import Data.Function

--Takes the input in two lines
main = interact $ show . findClosestToZero . readToInt . head . tail . lines 

readToInt :: String -> [Integer]
readToInt a = map read $ words a :: [Integer]

findClosestToZero :: [Integer] -> Integer
findClosestToZero a = case (a /= []) of
    True -> minimumBy (compare `on` distanceToZero ) a 
    False -> 0

distanceToZero :: Integer -> Integer
distanceToZero a = case (a < 0) of 
  True -> abs a + 1
  False -> a
