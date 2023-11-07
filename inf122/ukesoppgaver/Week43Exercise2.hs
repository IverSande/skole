{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

{-# LANGUAGE StandaloneDeriving #-}
module Week43Exercise2 where


import qualified Data.Map as Map 
import Data.Map (Map) 
import qualified Data.Set as Set
import Data.Set (Set)
import Data.Maybe

type MyGraph n = Map n (Set n)

class IntegerGraph g where
  emptyGraph :: g
  insertNode :: Integer -> g -> g
  insertEdge :: Integer -> Integer -> g -> g
  nodeInGraph :: Integer -> g -> Bool
  edgeInGraph :: Integer -> Integer -> g -> Bool

instance Show (MyGraph n) where
  show (myGraph n) = show n

instance IntegerGraph (MyGraph Integer) where 
  emptyGraph = Map.empty
  insertNode n g = Map.insert n (Set.empty) g
  insertEdge n m g = bridge n m g 
  nodeInGraph n g = Map.member n g 
  edgeInGraph n m g = edge g n m



edge :: (Ord node)
     => MyGraph node -> node -> node -> Bool
edge g x y = case Map.lookup x g of
       Nothing -> False
       (Just edges) -> Set.member y edges

path :: (Ord node)
     => MyGraph node -> node -> node -> Maybe [node]
path g start end = path' g start end Set.empty


path' :: (Ord node)
     => MyGraph node
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
bridge :: (Ord n) => n -> n -> MyGraph n -> MyGraph n
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
