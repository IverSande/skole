module Week37Exercise1 where
  semiFermat :: Integer -> Integer -> [(Integer, Integer, Integer)]
  semiFermat n m = [(a, b, c) | a <- [1..n], b <- [1..n], c <- [1..n], ((a^m) + (b^m) == (c^(m-1)))]











