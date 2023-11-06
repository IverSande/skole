module Week43Exercise2 where

{-# LANGUAGE FlexibleInstances #-}

import qualified Data.Map as Map
import Data.Map (Map)
import qualified Data.Set as Set
import Data.Set (Set)

data MyGraph n = Map n (Set n)
  deriving(Show)
  
class IntegerGraph g where
  emptyGraph :: g
  insertNode :: Integer -> g -> g
  insertEdge :: Integer -> Integer -> g -> g
  nodeInGraph :: Integer -> g -> Bool
  edgeInGraph :: Integer -> Integer -> g -> Bool


instance Num n => IntegerGraph (MyGraph n) where 
  emptyGraph = undefined
  insertNode = undefined
  insertEdge = undefined
  nodeInGraph = undefined
  edgeInGraph = undefined



