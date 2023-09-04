module Week36Exercise1 where
  f :: [Integer] -> [t] -> [(Integer, t)]
  f a b = zip ( a ++ reverse a ) (b ++ reverse b)  
  





