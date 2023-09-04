module Week36Exercise0 where
  f :: String -> Char -> Bool

  f a b = not (b `elem` a)  
