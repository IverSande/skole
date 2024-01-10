import Debug.Trace

main = 
  readFile "files/des8.txt" >>= \x -> 
  let a = head $ lines x in
  let b = tail $ lines x in
  let c = map makeInputMap b in
  let d = finder c a a "AAA" 0 in
  putStrLn $ show d

pain = 
  readFile "files/des8.txt" >>= \x -> 
  let a = head $ lines x in
  let b = tail $ lines x in
  let c = map makeInputMap b in
  let d = filter (\y -> (y !! 2) == 'A') b in
  let e = map (\u -> finder c a a u 0) (map (\z -> (words z) !! 0) d) in
  putStrLn $ show e

finder2 :: [(String, (String, String))] -> String -> String -> [String] -> Int -> Int
finder2 theMap _ fullList currentElem counter | trace (show currentElem) False = undefined
finder2 theMap [] fullList currentElem counter = finder2 theMap fullList fullList currentElem counter
finder2 theMap (x:xs) fullList currentElem counter = 
  if isZ currentElem then counter else
  case x of
    'R' -> finder2 theMap xs fullList (map snd $ lookupEr currentElem theMap) (counter+1) 
    'L' -> finder2 theMap xs fullList (map fst $ lookupEr currentElem theMap) (counter+1) 

lookupEr :: [String] -> [(String, (String, String))] -> [(String, String)]
lookupEr [] _ = []
lookupEr (x:xs) theMap = case lookup x theMap of
  Just a -> a : lookupEr xs theMap

isZ :: [String] -> Bool
isZ [] = True
isZ (x:xs) = if (x !! 2) /= 'Z' then False else isZ xs






finder :: [(String, (String, String))] -> String -> String -> String -> Int -> Int
finder _ _ _ [x, y, 'Z'] counter = counter
finder theMap [] fullList currentElem counter = finder theMap fullList fullList currentElem counter
finder theMap (x:xs) fullList currentElem counter = case x of
  'R' -> case lookup currentElem theMap of
           Just a -> finder theMap xs fullList (snd a) (counter+1)
  'L' -> case lookup currentElem theMap of
           Just a -> finder theMap xs fullList (fst a) (counter+1)


makeInputMap :: String -> (String, (String, String))
makeInputMap xs = let a = words xs in 
  (a !! 0, (a !! 1, a !! 2))




