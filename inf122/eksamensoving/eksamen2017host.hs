
harEl :: (t -> Bool) -> [t] -> Bool
harEl pr xs = or (map pr xs)

--Non exaustive
el :: (t -> Bool) -> [t] -> t
el pr (x:xs) = if (pr x) then x else el pr xs


gRep :: (t -> Bool) -> t -> [t] -> [t]
gRep _ _ [] = []
gRep pr a (x:xs) = if (pr x) 
  then a : gRep pr a xs 
  else x : gRep pr a xs 


data BT = B Int | N BT Int BT

elt :: BT -> Int -> Bool
elt (B a) b = a == b 
elt (N x a y) b = if a == b then True else elt x b || elt y b

--Sto ikke noe om sortering
toL :: BT -> [Int]
toL (B a) = [a]
toL (N x a y) = a : (toL x) ++ (toL y)

dup :: BT -> Bool 
dup a = dupHelp $ toL a

dupHelp :: [Int] -> Bool
dupHelp [] = False
dupHelp (a:as) = if elem a as then True else dupHelp as

tap :: Num t => [(t,t)] 
tap  = [(1,2), (1,3), (2,4), (3,2), (4,3), (4,5)]

naboL :: Eq t => [(t,t)] -> [(t,[t])]
naboL (kl) = let points = removeDuplicates $ map(\(x,_) -> x ) kl in 
  map (\x -> (x, removeDuplicates [y | y <- map snd kl, elem y ())])) points 


removeDuplicates :: Eq t => [t] -> [t]
removeDuplicates [] = []
removeDuplicates (x:xs) = if (elem x xs) then removeDuplicates xs else x : removeDuplicates xs










