

module Week38Exercise0 where
  runningSum :: [Integer] -> [Integer]
  runningSum [] = []
  runningSum [x] = [x]
  runningSum (x:y:xs) = x : runningSum((x+y):xs) 





