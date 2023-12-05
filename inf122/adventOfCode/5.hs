import Data.Tuple
import Debug.Trace

main =
  readFile "files/des5.txt" >>= \x ->
  let a = computeSeedrange (head $ parseSeeds (head $ lines x)) (filter (/= []) $ parseAllLinesToMaps (tail $ lines x) []) 100000000 in
  putStrLn $ show a



--findLowestSeedLoc :: [Int] -> [[((Int,Int),(Int, Int))]] -> Int
--findLowestSeedLoc (xs) locMap = minimum $ map (\x -> findLocationForSeed x locMap) xs

findLocationForSeed :: Int -> [[((Int,Int),(Int, Int))]] -> Int
findLocationForSeed num [] = num
findLocationForSeed num (x:xs) = findLocationForSeed (lookupInMap num x) xs

computeSeedrange :: (Int, Int) -> [[((Int,Int),(Int,Int))]] -> Int -> Int
computeSeedrange (a,b) full lowest = case a == b of
  True -> lowest
  False -> if findLocationForSeed a full < lowest 
    then computeSeedrange ((a+1), b) full (findLocationForSeed a full) 
    else computeSeedrange ((a+1), b) full lowest

--computeSeedrange :: (Int,Int) -> [[((Int,Int),(Int,Int))]] -> Int -> Bool -> Int
--computeSeedrange _ _ s True = s
--computeSeedrange (a, b) theMap smallestLoc fin = if(findLocationForSeed a theMap) < smallestLoc 
--  then computeSeedrange ((a+1),b) theMap (findLocationForSeed a theMap) (if a == b then True else False)
--  else computeSeedrange ((a+1),b) theMap smallestLoc (if a == b then True else False)


lookupInMap :: Int -> [((Int,Int),(Int,Int))] -> Int
--lookupInMap val xs | trace (show xs) False = undefined
lookupInMap val [] = val
lookupInMap val (((a,b),(c,d)):xs) = if between a b val then c + (val - a) else lookupInMap val xs


between :: Int -> Int -> Int -> Bool
between lower upper num = if (num > lower - 1) && (num < upper + 1) then True else False

parseSeeds :: String -> [(Int,Int)]
--parseSeeds xs | trace (show $ parseSeeds' $ map read (tail $ words xs)) False = undefined
parseSeeds xs = parseSeeds' $ map read (tail $ words xs)

parseSeeds' :: [Int] -> [(Int, Int)]
parseSeeds' [] = [] 
parseSeeds' [x] = []
parseSeeds' (x:y:xs) = [(x, x+y)] ++ parseSeeds' xs

parseSeeds1 :: String -> [Int]
parseSeeds1 xs = map read (tail $ words xs)

parseAllLinesToMaps :: [String] -> [String] -> [[((Int, Int), (Int, Int))]]
parseAllLinesToMaps [] _ = []
parseAllLinesToMaps (x:xs) acc = if (length $ words x) /= 3 
  then (parseLinesToMap acc) : parseAllLinesToMaps xs []
  else parseAllLinesToMaps xs (acc ++ [x])

--Takes lines for each mapping returns [((FromStart, FromEnd), (ToStart, Length from start to end))]
parseLinesToMap :: [String] -> [((Int, Int), (Int, Int))]
parseLinesToMap [] = []
parseLinesToMap (x:xs) = let y = map read (words x) in [(((y !! 1), (y !! 1) + (if (y !! 2) == 0 then 0 else (y !! 2) - 1 )), ((y !! 0), (y !! 2)))] ++ parseLinesToMap xs

--mapFromTo :: Int -> Int -> Int -> [(Int, Int)]
--mapFromTo to from length = zip [from..(from+length)] [to..(to+length)]









