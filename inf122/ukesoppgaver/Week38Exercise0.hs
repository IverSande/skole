

module Week38Exercise0 where
  runningSum :: [Integer] -> [Integer]
  runningSum [] = []
  runningSum [x] = [x]
<<<<<<< HEAD
  runningSum (x:y:xs) = x : runningSum((x+y):xs)
=======
  runningSum (x:y:xs) = x : runningSum((x+y):xs) 
>>>>>>> e80710b875c3980ca5093ab3bf1fcedbccba2118





