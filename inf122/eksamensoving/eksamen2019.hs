

-- matriser er [[Int]] der hver liste er en rad
--
-- antar at alle er fullstendige, har ikke med feilhaandtering ihvertfall ikke paa de mer komplekse

row :: [[Int]] -> Int -> [Int]
row list rownr = rownr !! list

row' :: [[Int]] -> Int -> [Int]
row' list rownr = case rownr !? list of
  Just a = a
  Nothing = [-1]

col :: [[Int]] -> Int -> [Int]
col [] = []
col (x:xs) colnr = (colnr !! x) : col xs colnr

cols :: [[Int]] -> [[Int]] 
cols (xs) = cols' xs 0

cols' :: [[Int]] -> Int -> [[Int]]
cols' (xs) counter = if counter == (length xs-1) then [[]] else (col xs counter) : (cols' xs (counter +1))

mult :: [[Int]] -> [[Int]] -> [[Int]]
mult xs ys = 

mult' :: [[Int]] -> [Int] -> [[Int]]
mult' xs ys = 


sumTupMul :: [(Int, Int)] -> Int
sumTupMul xs = sum $ map (\(x,y) -> x*y) xs



