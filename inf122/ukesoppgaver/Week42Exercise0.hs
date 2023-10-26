module Week42Exercise0 where

applyFunctions :: [a -> b] -> [b -> c] -> [a] -> [c]
applyFunctions [] _ _ = []
applyFunctions _ [] _ = []
applyFunctions _ _ [] = []
applyFunctions (x:xs) (y:ys) (z:zs) = [y $ x z] ++ applyFunctions xs ys zs
