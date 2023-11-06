module Week43Exercise0 where


data BinSearchTree a
  = Leaf a
  | LeftRightChildBranch (BinSearchTree a) a (BinSearchTree a)
  | LeftChildBranch (BinSearchTree a) a
  | RightChildBranch a (BinSearchTree a)
  deriving (Eq, Show)


foldr :: (a -> b -> b) -> b -> t a -> b
foldr f d bintree = 


