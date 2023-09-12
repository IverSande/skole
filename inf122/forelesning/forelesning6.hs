

import Prelude hiding (zip, map, (++), reverse)

zip :: [a] -> [b] -> [(a, b)]
zip [] _ = []
zip _ [] = []
zip (a:as) (b:bs) = (a,b) : zip as bs

map :: (a->b) -> [b] -> [b]
map f [] = []
map f (a:as) = f a : map f as


(++) :: [a] -> [a] -> [a]
[] ++ bs = bs
(a:as) ++ bs = a : (as ++ bs)

reverse' :: [a] -> [a] -> [a]
reverse' [] acc = acc
reverse' (a:as) acc = reverse as (a:acc)

reverse :: [a] -> [a]
reverse as = reverse' as []


