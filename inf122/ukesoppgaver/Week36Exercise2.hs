module Week36Exercise2 where
  split :: [t] -> ([t], [t])
  split myList = splitAt (((length myList)) `div` 2) myList

  semiRepetitive :: String -> Maybe String
  semiRepetitive a =
    case((fstASplit) == (sndASplit)) || (fstASplit == (tail sndASplit)) of
      True -> Just fstASplit
      False -> Nothing
    where 
      fstASplit = fst(split a)
      sndASplit = snd(split a)



  decomposeSemiRepetitive :: String -> Maybe (String, Maybe Char)
  decomposeSemiRepetitive a =
    case((fst(split a)) == (snd(split a))) || ((fst(split a)) == (tail(snd(split a)))) of
      True -> case(fst(split a)) == (snd(split a)) of
        True -> Just((fst(split a)), Nothing)
        False -> Just((fst(split a)), Just(head(snd(split a))))
      False -> Nothing

  createSemiRepetitive :: String -> Maybe Char -> String
  createSemiRepetitive a b = a ++ maybe "" (: "") b ++ a

  createSemiRepetitive2 :: String -> Maybe Char -> String
  createSemiRepetitive2 a b = a ++ maybe "" (: "") b  ++ a
