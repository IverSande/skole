
--f [] --tom list
--f (x:xs) --minst et elements
--f [x] -- akkuratt et element
--f (x:y:z:xs) -- minst 3 elements
--f [x, y, z] --noyaktig 3 elementer
--f xs --alle lister

-- g [1,2,3]
-- g [x,y,3]
--
-- [5,4..1] [5, 4, 3, 2, 1]
--
-- [x | (x,True) <- [(1, True), (2, False), (3, True)]] = [1,3]
--
-- type er bare et alias
--
-- data lager en type
--
-- typeklasse er f.eks ord, num, eq. En mengde med ting som har like egenskaper, som interface
--
-- 
-- 
  runningSum (x:y:xs) = x : runningSum((x+y):xs) 












