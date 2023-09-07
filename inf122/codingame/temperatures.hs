main = interact $ show . findClosestToZero . lines 

findClosestToZero :: [String] -> String 
findClosestToZero a = show $ findClosestToZeroString (a !! 1)

findClosestToZeroString :: String -> Integer
findClosestToZeroString a =  (map read(map (\x -> [x]) a) :: [Integer]) !! 1
