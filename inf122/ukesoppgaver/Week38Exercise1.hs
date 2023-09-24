<<<<<<< HEAD

module Week38Exercise1 where
  combinations :: Integer -> [Char] -> [String]
  combinations a [] = []
  combinations 0 b = [] 
  combinations a (x:xs) = (x : combinations (a-1) xs ) ++ combinations a xs 







=======
module Week38Exercise1 where
  combinations :: Integer -> [Char] -> [String]
  combinations 0 _ = [""]
  combinations a b = [x : xs | x <- b, xs <- combinations (a-1) b]
>>>>>>> e80710b875c3980ca5093ab3bf1fcedbccba2118

