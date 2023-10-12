module Week41Exercise0 where

import Data.Map (Map)
import qualified Data.Map as Map
import Data.Set (Set)
import qualified Data.Set as Set

type Graph n = Map n (Set n)

bridge :: (Ord n) => n -> n -> Graph n -> Graph n
bridge n1 n2 g = 
  case Map.member n1 g of
    True -> case Map.member n2 g of
      True -> Map.insertWith (Set.union) n1 (Set.fromList [n2]) g
      False -> Map.union (Map.insertWith (Set.union) n1 (Set.fromList [n2]) g) ((Map.fromList [(n2, Set.empty)] )) 
    False -> Map.union g (Map.union ((Map.fromList [(n1, Set.fromList [n2])])) ((Map.fromList [(n2, Set.empty)] )))




