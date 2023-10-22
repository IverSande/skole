module Week42Exercise1 where
import Data.Either

fromLeftAndRight :: (Either a b -> c) -> (a -> c, b -> c)
fromLeftAndRight ethab = (\a -> ethab(Left a), \b -> ethab (Right b))


either' :: (a -> c) -> (b -> c) -> Either a b -> c
either' f g = either f g 


toFstAndSnd :: (a -> (b,c)) -> (a -> b, a -> c)
toFstAndSnd f = (\a -> fst $ f a , \b -> snd $ f b)


pair :: (a -> b) -> (a -> c) -> a -> (b, c)
pair f g = (\a -> (f a, g a))




