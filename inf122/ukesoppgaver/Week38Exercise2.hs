module Week38Exercise2 where
  import Data.Maybe
  removeNothing :: [Maybe a] -> [a]
  removeNothing [] = []
  removeNothing (x:xs) = 
    if isNothing x 
    then removeNothing xs 
    else fromJust x : removeNothing xs 

