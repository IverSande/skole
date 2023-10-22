module Week42Exercise2 where

isFiveMultiples :: [Integer] -> Bool
isFiveMultiples = and . map (==0) . map ((\b -> mod b 5)) 

isFiveMultiples' :: [Integer] -> Bool
isFiveMultiples' a = and $ map (==0) $ map ((\b -> mod b 5)) a


factorial :: Integer -> Integer
factorial = (\ a -> foldr (*) 1 [1..a]) 

factorial' :: Integer -> Integer
factorial' a = foldr (*) 1 [1..a]






