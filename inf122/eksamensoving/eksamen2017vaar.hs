

--lengthsum :: (Num a, Num b) => [a] -> (b, a)
--lengthsum xs = (length xs , foldr (+) 0 xs)

lengthsum' :: (Num a, Num b) => [a] -> (b, a)
lengthsum' xs = (foldr (\x -> (+1)) 0 xs, foldr (+) 0 xs)

--lengthsumNoLength xs = (foldr (\x -> (+1)) 0 xs) //litt usikker her


inList :: (Eq a) => a -> [a] -> Bool
inList a xs = foldl (\bool x -> if x == a then True else bool) False xs

 

data Expr = V Int | M Expr Expr | D Expr Expr

eval :: Expr -> Maybe Int
eval (V a) = Just a
eval (M a b) = case eval a of 
  Nothing -> Nothing 
  Just x -> case eval b of
    Nothing -> Nothing
    Just y -> if (x < 0 || y < 0) then Nothing
                else Just (x * y)
eval (D a b) = case eval a of
  Nothing -> Nothing
  Just x -> case eval b of
    Nothing -> Nothing
    Just y -> if (y == 0) then Nothing
                else Just (div x y)
--eval (M a b) = if (eval a == Nothing || eval b == Nothing || (fromJust $ eval a) < 0 || (fromJust $ eval b) < 0) then Nothing
--  else (fromJust $ eval a) * (fromJust $ eval b)
--eval (D a b) = if (eval a == Nothing || eval b == Nothing || (fromJust $ eval b) == 0) then Nothing 
--  else (fromJust $ eval a) `div` (fromJust $ eval b)



data Month = January | February | March | April | Mai | June | July | August | September | October | November | Desember


numDays :: Month -> Integer -> Integer 
numDays month year = case month of 
  January -> 31
  February -> if (year `mod` 4 == 0) then 29 else 28
  March -> 31
  April -> 30
  Mai -> 31
  June -> 30 
  July -> 31
  August -> 31
  September -> 30
  October -> 31
  November -> 30
  Desember -> 31



toDoList :: [IO a] -> IO [a]
toDoList [] = return []
toDoList (x:xs) = do 
  v <- x
  vs <- toDoList xs
  return (v : vs)


mapActions :: (a -> IO b) -> [a] -> IO [b]
mapActions _ [] = return []
mapActions f (x:xs) = do
  y <- (f x) 
  ys <- mapActions f xs 
  return (y:ys)



