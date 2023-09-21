module Week38Exercise1 where
  combinations :: Integer -> [Char] -> [String]
  combinations 0 _ = [""]
  combinations a b = [x : xs | x <- b, xs <- combinations (a-1) b]

