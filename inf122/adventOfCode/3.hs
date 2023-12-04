import Debug.Trace

main :: IO String
main =  
  readFile "files/des3.txt" >>= \x ->
  putStrLn ( show $ findThingsForThings (lines x) (lines x) (length ((head $ lines x))-1) ((length (lines x))-1) 0) >>
  return x


findThingsForThings :: [String] -> [String] -> Int -> Int -> Int -> Int
findThingsForThings _ _ _ h _ | trace (show h) False = undefined
findThingsForThings [] _ _ _ _ = 0
findThingsForThings (x:xs) wholeThing width height currentH = findThings x wholeThing width height currentH 0 [] + findThingsForThings xs wholeThing width height (currentH + 1)

findThings :: String -> [String] -> Int -> Int -> Int -> Int -> String -> Int
--findThings _ _ _ _ _ _ a | trace a False = undefined
findThings [] _ _ _ _ _ _ = 0
findThings (x:xs) wholeThing width height currentH currentW numAcc = 
  case compareToNum x of
    True -> if(currentW == width)
      then if(computeLegal (numAcc ++ [x]) wholeThing currentW currentH width height) 
        then (read (numAcc ++ [x])) + findThings xs wholeThing width height currentH (currentW) []
        else findThings xs wholeThing width height currentH (currentW) []
      else if(compareToNum $ head xs)
        then findThings xs wholeThing width height currentH (currentW+1) (numAcc ++ [x])
        else if(computeLegal (numAcc ++ [x]) wholeThing currentW currentH width height) 
          then (read (numAcc ++ [x])) + findThings xs wholeThing width height currentH (currentW + 1) []
          else findThings xs wholeThing width height currentH (currentW +1) []
    False -> findThings xs wholeThing width height (currentH) (currentW+1) numAcc


computeLegal :: String -> [String] -> Int -> Int -> Int -> Int -> Bool
computeLegal xs _ x y _ _ | trace (xs ++ "(" ++ (show x) ++ "," ++ (show y) ++ ")") False = undefined
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
  '1' -> False
  '2' -> False
  '3' -> False
  '4' -> False
  '5' -> False
  '6' -> False
  '7' -> False
  '8' -> False
  '9' -> False
  '0' -> False
  '.' -> False
  otherwise -> True










