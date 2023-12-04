--main :: IO String
--main = 
--  readFile "files/des4.txt" >>= \x -> 
--  let a = sum $ map (\y -> howMany (doThing $ words y) 0) (lines x) in
--  putStrLn (show a) >>
--  return ":)"

main :: IO String
main = 
  readFile "files/des4.txt" >>= \x -> 
  let a = countUpAll2 (lines x) (lines x)   in
  putStrLn (show a) >>
  return ":)"



doThing :: [String] -> ([String], [String])
doThing xs = (drop 2 (takeWhile ( /= "|") xs), (takeWhile (/= "|") (reverse xs)))

howMany :: ([String], [String]) -> Int -> Int
howMany ([], ys) counter = if counter == 0 then 0 else 2^(counter-1)
howMany ((x:xs), ys) counter = if elem x ys then howMany (xs, ys) (counter + 1) else howMany (xs, ys) counter


--Takes lines
countUpAll2 :: [String] -> [String] -> Int
countUpAll2 [] _ = 0
countUpAll2 (x:xs) fullThing = (countUpAll2 (take (howMany2 (doThing2 $ words x) 0) (reverse $ takeWhile (/= x) $ reverse fullThing)) fullThing) + (countUpAll2 xs fullThing) + 1


doThing2 :: [String] -> ([String], [String])
doThing2 xs = (drop 2 (takeWhile ( /= "|") xs), (takeWhile (/= "|") (reverse xs)))

howMany2 :: ([String], [String]) -> Int -> Int
howMany2 ([], ys) counter = if counter == 0 then 0 else counter
howMany2 ((x:xs), ys) counter = if elem x ys then howMany2 (xs, ys) (counter + 1) else howMany2 (xs, ys) counter

