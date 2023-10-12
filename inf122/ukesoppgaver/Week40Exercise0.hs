module Week40Exercise0 where
  import Data.Maybe
  data SemiRepetitive = SemiRepetitive String (Maybe Char) 
    deriving (Show)
  
  semiRepetitive :: String -> Maybe SemiRepetitive
  semiRepetitive a = 
    case isNothing $ decomposeSemiRepetitive a of
      True -> Nothing 
      False -> Just(SemiRepetitive (fst $ fromJust $ decomposeSemiRepetitive a) (snd $ fromJust $ decomposeSemiRepetitive a))

  toString :: SemiRepetitive -> String 
  toString (SemiRepetitive a b) = if isNothing b
    then a ++ a
    else a ++ [fromJust b] ++ a

      
  decomposeSemiRepetitive :: String -> Maybe (String, Maybe Char)
  decomposeSemiRepetitive a =
    case((fst(split a)) == (snd(split a))) || ((fst(split a)) == (tail(snd(split a)))) of
      True -> case(fst(split a)) == (snd(split a)) of
        True -> Just((fst(split a)), Nothing)
        False -> Just((fst(split a)), Just(head(snd(split a))))
      False -> Nothing
  
  split :: [t] -> ([t], [t])
  split myList = splitAt (((length myList)) `div` 2) myList

