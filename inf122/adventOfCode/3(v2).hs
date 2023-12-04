
import Debug.Trace

main :: IO String
main =  
  readFile "files/des3.txt" >>= \x ->
  let a = (  findStars (lines x) (lines x) (length ((head $ lines x)) -1) ((length (lines x))-1) 0) in 
--  putStrLn a >>
  let b = ( map fullThings $ filter (\y -> (fst y) /= "empty") $ findThingsForThings (lines x) (lines x) (length ((head $ lines x))-1) ((length (lines x))-1) 0) in
--  putStrLn b >>
  let c = filter (/=0) $ map (\x -> edgeTo x (head a)) b in

  let d = sum $ map (\y -> let q =(filter (/=0) $ map (\x -> edgeTo x (y)) b) in if length q == 2 then (head q)*(head $ tail q) else 0) a in
  putStrLn (show d )>>
  return ":)"



edgeTo :: (String, [(Int, Int)]) -> (Int, Int) -> Int
edgeTo (num, xs) star = if( foldr (\x y -> edgeToHelper x star || y) False xs) then read num else 0

edgeToHelper :: (Int, Int) -> (Int, Int) -> Bool
edgeToHelper (a, b) (c, d) = if elem (c,d) [(x, y) | x <- [a-1, a+1, a], y <- [b-1, b+1, b]] then True else False

fullThings :: (String, [(Int, Int)]) -> (String, [(Int, Int)])
fullThings (a, xs) = case length a of
  1 -> (a, xs)
  2 -> (a, [(((fst $ head xs)-1),(snd $ head xs))] ++ xs)
  3 -> (a, [(((fst $ head xs)-2),(snd $ head xs)), (((fst $ head xs)-1),(snd $ head xs))] ++ xs)

findStars :: [String] -> [String] -> Int -> Int -> Int -> [(Int, Int)]
findStars [] _ _ _ _ = []
findStars (x:xs) wholeThing width height currentH = (findStars2 x wholeThing width height currentH 0) ++ findStars xs wholeThing width height (currentH + 1)

findStars2 :: String -> [String] -> Int -> Int -> Int -> Int -> [(Int, Int)]
--findStars2 xs _ _ _ _ w | trace (show w) False = undefined
findStars2 [] _ _ _ _ _ = []
findStars2 (x:xs) wholeThing width height currentH currentW =
  case compareTo x of
    True -> [(currentW, currentH)] ++ findStars2 xs wholeThing width height currentH (currentW + 1)
    False -> findStars2 xs wholeThing width height currentH (currentW + 1)

findThingsForThings :: [String] -> [String] -> Int -> Int -> Int -> [(String, [(Int, Int)])]
--findThingsForThings _ _ _ h _ | trace (show h) False = undefined
findThingsForThings [] _ _ _ _ = [("empty", [])]
findThingsForThings (x:xs) wholeThing width height currentH = findThings x wholeThing width height currentH 0 [] ++ findThingsForThings xs wholeThing width height (currentH + 1)

findThings :: String -> [String] -> Int -> Int -> Int -> Int -> String -> [(String, [(Int, Int)])]
--findThings _ _ _ _ _ _ a | trace a False = undefined
findThings [] _ _ _ _ _ _ = [("empty", [])]
findThings (x:xs) wholeThing width height currentH currentW numAcc = 
  case compareToNum x of
    True -> if(currentW == width)
      then if(computeLegal (numAcc ++ [x]) wholeThing currentW currentH width height) 
        then [((numAcc ++ [x]), [(currentW,currentH)])]
        else [("empty", [])]
      else if(compareToNum $ head xs)
        then findThings xs wholeThing width height currentH (currentW+1) (numAcc ++ [x])
        else if(computeLegal (numAcc ++ [x]) wholeThing currentW currentH width height) 
          then [((numAcc ++ [x]), [(currentW,currentH)])] ++ findThings xs wholeThing width height currentH (currentW + 1) []
          else findThings xs wholeThing width height currentH (currentW +1) []
    False -> findThings xs wholeThing width height (currentH) (currentW+1) numAcc


computeLegal :: String -> [String] -> Int -> Int -> Int -> Int -> Bool
--computeLegal xs _ x y _ _ | trace (xs ++ "(" ++ (show x) ++ "," ++ (show y) ++ ")") False = undefined
computeLegal [] _ _ _ _ _ = False
computeLegal xs wholeThing x y width height = (checkLegal wholeThing (x,y) width height) || computeLegal (init xs) wholeThing (x-1) y width height 

checkLegal :: [String] -> (Int, Int) -> Int -> Int -> Bool
checkLegal xs (x,y) width height = 
  if (x == 0 && y == 0) 
    then (compareTo ((xs !! y) !! (x+1))) || (compareTo ((xs !! (y+1)) !! (x+1))) || (compareTo ((xs !! (y+1)) !! (x)))
    else if (x == 0 && y == height)
      then (compareTo ((xs !! y) !! (x+1))) || (compareTo ((xs !! (y-1)) !! (x+1))) || (compareTo ((xs !! (y-1)) !! (x)))
      else if(x == width && y == 0)
        then (compareTo ((xs !! y) !! (x-1))) || (compareTo ((xs !! (y+1)) !! (x-1))) || (compareTo ((xs !! (y+1)) !! (x)))
        else if(x == width && y == height)
          then (compareTo ((xs !! y) !! (x-1))) || (compareTo ((xs !! (y-1)) !! (x-1))) || (compareTo ((xs !! (y-1)) !! (x)))
          else if(x == 0)
            then (compareTo ((xs !! y) !! (x+1))) || (compareTo ((xs !! (y+1)) !! (x+1))) || (compareTo ((xs !! (y-1)) !! (x+1))) || (compareTo ((xs !! (y+1)) !! (x))) || (compareTo ((xs !! (y-1)) !! (x)))
            else if(x == width)
              then (compareTo ((xs !! y) !! (x-1))) || (compareTo ((xs !! (y+1)) !! (x-1))) || (compareTo ((xs !! (y-1)) !! (x-1))) || (compareTo ((xs !! (y+1)) !! (x))) || (compareTo ((xs !! (y-1)) !! (x)))
              else if (y == 0)
                then (compareTo ((xs !! y) !! (x+1))) || (compareTo ((xs !! (y)) !! (x-1))) || (compareTo ((xs !! (y+1)) !! (x+1))) || (compareTo ((xs !! (y+1)) !! (x))) || (compareTo ((xs !! (y+1)) !! (x-1)))
                else if (y == height)
                  then (compareTo ((xs !! y) !! (x+1))) || (compareTo ((xs !! (y)) !! (x-1))) || (compareTo ((xs !! (y-1)) !! (x+1))) || (compareTo ((xs !! (y-1)) !! (x))) || (compareTo ((xs !! (y-1)) !! (x-1)))
                  else (compareTo ((xs !! y) !! (x+1))) || (compareTo ((xs !! (y)) !! (x-1))) || (compareTo ((xs !! (y-1)) !! (x+1))) || (compareTo ((xs !! (y-1)) !! (x))) || (compareTo ((xs !! (y-1)) !! (x-1))) || (compareTo ((xs !! (y+1)) !! (x+1))) || (compareTo ((xs !! (y+1)) !! (x))) || (compareTo ((xs !! (y+1)) !! (x-1)))



compareToNum :: Char -> Bool
compareToNum a = case a of
  '1' -> True
  '2' -> True
  '3' -> True 
  '4' -> True
  '5' -> True 
  '6' -> True 
  '7' -> True 
  '8' -> True
  '9' -> True
  '0' -> True
  otherwise -> False

compareTo :: Char -> Bool
compareTo a = case a of
  '*' -> True
  otherwise -> False
