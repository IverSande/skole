module Week40Exercise2 where

data BinSearchTree a
  = Empty
  | Branch (BinSearchTree a) a (BinSearchTree a)
  deriving (Eq, Show)

toBinarySearchTree :: [a] -> BinSearchTree a
toBinarySearchTree (a:as) = Branch (Empty) a (toBinarySearchTree as)

