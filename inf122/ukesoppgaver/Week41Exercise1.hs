module Week41Exercise1 where
import qualified Data.Map as Map
import Data.Map (Map)
import qualified Data.Set as Set
import Data.Set (Set)

import Data.Maybe

type Graph node = Map node (Set node)



disjoint :: (Ord a) => Set a -> Set a -> Bool
disjoint a b = Set.null $ Set.intersection a b


hasCycle :: (Ord n) => Graph n -> n -> Bool
hasCycle g node = (hasCycleHelper g (Set.empty) node) > 0

hasCycleHelper :: (Ord n) => Graph n -> Set n -> n -> Int
hasCycleHelper g setOfVisited thisNode = 
  if (isNothing(Map.lookup thisNode g) || Set.null( fromJust(Map.lookup thisNode g)))
    then 0
    else 
      if not (disjoint (fromJust(Map.lookup thisNode g)) setOfVisited)
        then 1
        else 0 + (sum $ map (\x -> hasCycleHelper g (Set.insert thisNode setOfVisited) x) (Set.toList $ fromJust(Map.lookup thisNode g)))


