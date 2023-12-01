

readTheFile :: IO Int
readTheFile = do 
  a <- readFile "files/des1.txt"
  return $ sum $ map findTheNums $ lines a

findTheNums :: String -> Int
findTheNums [] = 0
findTheNums xs = read $ [findFirst xs] ++ [findFirst' $ reverse xs]



findFirst :: String -> Char
findFirst [] = '0'
findFirst (x:xs) = if(x == '1' || x == '2' || 
                      x == '3'|| x == '4'|| 
                      x == '5'|| x == '6'|| 
                      x == '7'|| x == '8'|| 
                      x == '9'|| x == '0')
  then x
  else case x of --if(x == 'o' || x == 't' || x == 'f' || x == 's' || x == 'e' || x == 'n')
    'o' -> case findWithLetters (x: take 2 xs) of 
      Nothing -> findFirst xs 
      Just a -> a 
    't' -> case findWithLetters (x: take 2 xs) of
      Just a -> a
      Nothing -> case findWithLetters (x: take 4 xs) of
        Nothing -> findFirst xs
        Just a -> a
    'f' -> case findWithLetters (x: take 3 xs) of
      Just a -> a
      Nothing -> findFirst xs
    's' -> case findWithLetters (x: take 2 xs) of
      Just a -> a
      Nothing -> case findWithLetters (x: take 4 xs) of
        Just a -> a
        Nothing -> findFirst xs
    'e' -> case findWithLetters (x: take 4 xs) of
      Just a -> a
      Nothing -> findFirst xs
    'n' -> case findWithLetters (x: take 3 xs) of
      Just a -> a
      Nothing -> findFirst xs
    otherwise -> findFirst xs


findWithLetters :: String -> Maybe Char
findWithLetters a = case a of
  "one" -> Just '1'
  "two" -> Just '2'
  "three" -> Just '3'
  "four" -> Just '4'
  "five" -> Just '5'
  "six" -> Just '6'
  "seven" -> Just '7'
  "eight" -> Just '8'
  "nine" -> Just '9'
  otherwise -> Nothing





findFirst' :: String -> Char
findFirst' [] = '0'
findFirst' (x:xs) = if(x == '1' || x == '2' || 
                      x == '3'|| x == '4'|| 
                      x == '5'|| x == '6'|| 
                      x == '7'|| x == '8'|| 
                      x == '9'|| x == '0')
  then x
  else case x of --if(x == 'o' || x == 't' || x == 'f' || x == 's' || x == 'e' || x == 'n')
    'e' -> case findWithLetters' (x: take 2 xs) of 
      Just a -> a
      Nothing -> case findWithLetters' (x: take 4 xs) of
        Just a -> a
        Nothing -> case findWithLetters' (x: take 3 xs) of
          Just a -> a
          Nothing -> findFirst' xs
    'o' -> case findWithLetters' (x: take 2 xs) of
      Just a -> a
      Nothing -> findFirst' xs
    'r' -> case findWithLetters' (x: take 3 xs) of
      Just a -> a
      Nothing -> findFirst' xs
    'x' -> case findWithLetters' (x: take 2 xs) of
      Just a -> a
      Nothing -> findFirst' xs
    'n' -> case findWithLetters' (x: take 4 xs) of
      Just a -> a
      Nothing -> findFirst' xs
    't' -> case findWithLetters' (x: take 4 xs) of
      Just a -> a
      Nothing -> findFirst' xs
    otherwise -> findFirst' xs


findWithLetters' :: String -> Maybe Char
findWithLetters' a = case a of
  "eno" -> Just '1'
  "owt" -> Just '2'
  "eerht" -> Just '3'
  "ruof" -> Just '4'
  "evif" -> Just '5'
  "xis" -> Just '6'
  "neves" -> Just '7'
  "thgie" -> Just '8'
  "enin" -> Just '9'
  otherwise -> Nothing
