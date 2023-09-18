
module Week38Exercise1 where
  combinations :: Integer -> [Char] -> [String]
  combinations a [] = []
  combinations 0 b = [] 
  combinations a (x:xs) = (x : combinations (a-1) xs ) ++ combinations a xs 








