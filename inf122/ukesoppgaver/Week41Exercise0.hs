module Week41Exercise0 where

import Data.Map (Map)
import qualified Data.Map as Map
import Data.Set (Set)
import qualified Data.Set as Set
import Data.Maybe
type Graph n = Map n (Set n)



edge :: (Ord node)
     => Graph node -> node -> node -> Bool
edge g x y = case Map.lookup x g of
       Nothing -> False
       (Just edges) -> Set.member y edges

path :: (Ord node)
     => Graph node -> node -> node -> Maybe [node]
path g start end = path' g start end Set.empty


path' :: (Ord node)
     => Graph node
     -> node -> node
     -> Set node
     -> Maybe [node]
path' g start end visited
  | Set.member start visited = Nothing
        -- We have reached a cycle
  | start == end = Just []
  | otherwise
    = do
       let visited' = Set.insert start visited
       nexts <- Map.lookup start g
       listToMaybe
         $ mapMaybe
            (\next -> do
               pathCont <- path' g next end visited'
               Just (next:pathCont))
            (Set.toList nexts)
            

bridge :: (Ord n) => n -> n -> Graph n -> Graph n
bridge n1 n2 g = 
  case Map.member n1 g of
    True -> case Map.member n2 g of
      True -> if (isJust(path g n1 n2)) 
      then g 
      else Map.insertWith (Set.union) n1 (Set.fromList [n2]) g 
      False -> Map.union (Map.insertWith (Set.union) n1 (Set.fromList [n2]) g) ((Map.fromList [(n2, Set.empty)] )) 
    False -> if(Map.member n2 g) 
      then Map.union g ((Map.fromList [(n1, Set.fromList [n2])])) 
      else Map.union g (Map.union ((Map.fromList [(n1, Set.fromList [n2])])) ((Map.fromList [(n2, Set.empty)] )))
