



main :: IO()
main = 
  putStrLn "Hva heter du til fornavn?" >>
  getLine >>= \x ->
 -- putStrLn ( head $ reverse x) : (tail $ reverse x)
  putStrLn (( head $ reverse x) : (tail $ reverse x)) >>
  --putStrLn ((toUpper $ head $ reverse x) : (tail $ reverse x)) >>
  return ()

--reverse :: String -> String
--reverse [] = []
--reverse (x:xs) = reverse xs : x


sumOfSquares :: [Integer] -> Integer
sumOfSquares xs = sum [x*x | x <- xs]

sumOfSquares' :: [Integer] -> Integer
sumOfSquares' xs = sum $ map (\x -> x*x) xs

duplicate :: [a] -> [a]
duplicate [] = []
duplicate (x:xs) = x : x : duplicate xs


product :: [Integer] -> Integer
product xs = foldr (\x y -> x * y) 1 xs

hasLength :: Int -> [a] -> Bool
hasLength a xs = hasLength' a 0 xs

hasLength' :: Int -> Int -> [a] -> Bool
hasLength' a b [] = if a == b then True else False
hasLength' length counter (x:xs) = if counter > length then False else hasLength' length (counter+1) xs



data Record key value = Record (Map key (Either(Record key value) value))

shallowUnion :: (Ord key) => Record key value -> Record key value -> Record key value
shallowUnion Record(rec1) Record(rec2) = Record (union rec1 rec2)

deepUnion :: (Ord key) => Record key value -> Record key value -> Record key value
deepUnion Record(rec1) Record(rec2) = unionWith (\x y -> if x == Left && y == Left then deepUnion x y else x) rec1 rec2








