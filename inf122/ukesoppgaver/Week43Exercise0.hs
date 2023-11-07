module Week43Exercise0 where
--import Prelude hiding (foldr)
data BinSearchTree a
  = Leaf a
  | LeftRightChildBranch (BinSearchTree a) a (BinSearchTree a)
  | LeftChildBranch (BinSearchTree a) a
  | RightChildBranch a (BinSearchTree a)
  deriving (Eq, Show)

instance Foldable BinSearchTree where
--  foldr :: (a -> b -> b) -> b -> BinSearchTree a -> b
  foldr f d bintree = 
    case bintree of
      Leaf a -> f a d
      LeftRightChildBranch treeleft a treeright -> foldr f (f a (foldr f d treeright)) treeleft
      LeftChildBranch treeleft a -> foldr f (f a d) treeleft
      RightChildBranch a treeright -> f a (foldr f d treeright) 

toList :: BinSearchTree a -> [a]
toList a = foldr (:) [] a
