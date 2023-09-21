
--
--data BinTree a = Empty | Branch (BinTree a) a (BinTree a)
--  deriving (Eq, Show)
--
--leaf :: a -> BinTree a
--leaf a = Branch Empty a Empty
--
--
--t1 :: BinTree Integer
--t1 = Branch (Branch (leaf 1) 2 (leaf 3)) 
--             4
--             (leaf 5)
--
--treeSum :: BinTree Integer -> Integer
--treeSum Empty = 0
--treeSum (Branch lefts a rights) 
--  = a + treeSum lefts + treeSum rights
--
--toList :: BinTree a -> [a]
--toList Empty = []
--toList (Branch lefts a rights)
-- = toList lefts ++ [a] ++ toList rights
--
--height :: BinTree a -> Integer
--height Empty = 0
--height (Branch lefts _ rights)
--  = 1 + max (height lefts) (height rights)
--
--
--data Parity = Even | Odd
--  deriving (Eq, Show)
--
---- This function is O(n)
--listParity :: [a] -> Parity
--listParity [] = Even
--listParity (a:as) = case listParity as of 
--  Even -> Odd
--  Odd -> Even
--
--data ParityList a = Empty | Cons Parity a (ParityList a)
--  deriving (Eq, Show)
----Cons Odd 1 (Cons Even 2 (Cons Odd 1 Empty))
--
--cons :: a -> ParityList a -> ParityList a
--cons a Empty = Cons Odd a Empty
--cons a as@(Cons Even b bs) = Cons Odd a as
--cons a as@(Cons Odd b bs) = Cons Even a as
--

data SortedList a = Empty | Cons  a (SortedList a)
  deriving (Eq, Show)


insert :: (Ord a ) => a -> SortedList a -> SortedList a
insert a Empty = Cons a Empty
insert a (Cons b bs) = if a <= b 
                       then Cons (a as)
                       else a >= Cons b (insert a bs) 


fromList :: (Ord a) => [a] -> SortedList a 
fromList [] = Empty
fromList (a:as) = insert a (fromList as)

toList :: SortedList a -> [a]
toList Empty = []
toList (Cons a as) = a : toList as















