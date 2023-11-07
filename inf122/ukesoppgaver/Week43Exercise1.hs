module Week43Exercise1 where

data RoseTree a = Branch a [RoseTree a]
  deriving (Eq, Show)

instance Functor RoseTree where
--fmap :: (a -> b) -> f a -> f b
  fmap g rose = case rose of 
    Branch a [] -> Branch (g a) []
    Branch a xs -> Branch (g a) $ map (\x -> fmap g x) xs
 -- fmap f a = undefined
  
productNodes :: (Num a) => RoseTree [a] -> RoseTree a
productNodes tree = fmap (\x -> foldr (*) 1 x) tree   





