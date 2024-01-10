import Data.List

main = 
  readFile "files/des7.txt" >>= \x ->
  let a = map words $ lines x in
  let b = sortBy sortHelp a in
  let q = zip b (map findTypeHand (map head b)) in
  let c = zip (map read $ map last b) [1..] :: [(Int, Int)] in
  let d = foldr (\(b,n) m -> b * n + m) 0 c in
  putStrLn $ show d

pain = 
  readFile "files/des7.txt" >>= \x ->
  let a = map words $ lines x in
  let b = sortBy sortHelp2 a in
  let q = zip b (map findTypeHand2 (map head b)) in
  let c = zip (map read $ map last b) [1..] :: [(Int, Int)] in
  let d = foldr (\(b,n) m -> b * n + m) 0 c in
  putStrLn $ show d


data HandType = HighCard | OnePair | TwoPair | ThreeOfAKind | FullHouse | FourOfAKind | FiveOfAKind
  deriving (Show, Eq)

sortHelp :: [String] -> [String] -> Ordering
sortHelp  xs ys = case compareHands (head xs) (head ys) of
 EQ -> EQ
 GT -> GT
 LT -> LT

--Returns ordering 
compareHands :: String -> String -> Ordering
compareHands xs ys = case compare (findTypeHand xs) (findTypeHand ys) of
 GT -> GT
 LT -> LT
 EQ -> compareCards xs ys


sortHelp2 :: [String] -> [String] -> Ordering
sortHelp2  xs ys = case compareHands2 (head xs) (head ys) of
 EQ -> EQ
 GT -> GT
 LT -> LT

--Returns ordering 
compareHands2 :: String -> String -> Ordering
compareHands2 xs ys = case compare (findTypeHand2 xs) (findTypeHand2 ys) of
 GT -> GT
 LT -> LT
 EQ -> compareCards2 xs ys


compareCards :: String -> String -> Ordering
compareCards [] [] = EQ
compareCards (x:xs) (y:ys) = if x==y then compareCards xs ys else 
  case (x,y) of
    ('A', y) -> GT
    ('K', y) -> if y == 'A' then LT else GT
    ('Q', y) -> if y == 'A' || y == 'K' then LT else GT
    ('J', y) -> if y == 'A' || y == 'K' || y == 'Q' then LT else GT
    ('T', y) -> if y == 'A' || y == 'K' || y == 'Q' || y == 'J' then LT else GT
    (y, 'A') -> LT
    (y, 'K') -> if y == 'A' then GT else LT
    (y, 'Q') -> if y == 'A' || y == 'K' then GT else LT
    (y, 'J') -> if y == 'A' || y == 'K' || y == 'Q' then GT else LT
    (y, 'T') -> if y == 'A' || y == 'K' || y == 'Q' || y == 'J' then GT else LT
    (x, y)   -> if (read [x] :: Int) > (read [y] :: Int) then GT else LT

compareCards2 :: String -> String -> Ordering
compareCards2 [] [] = EQ
compareCards2 (x:xs) (y:ys) = if x==y then compareCards2 xs ys else 
  case (x,y) of
    ('A', y) -> GT
    ('K', y) -> if y == 'A' then LT else GT
    ('Q', y) -> if y == 'A' || y == 'K' then LT else GT
    ('J', y) -> LT 
    ('T', y) -> if y == 'A' || y == 'K' || y == 'Q' then LT else GT
    (y, 'A') -> LT
    (y, 'K') -> if y == 'A' then GT else LT
    (y, 'Q') -> if y == 'A' || y == 'K' then GT else LT
    (y, 'J') -> GT 
    (y, 'T') -> if y == 'A' || y == 'K' || y == 'Q' then GT else LT
    (x, y)   -> if (read [x] :: Int) > (read [y] :: Int) then GT else LT

findTypeHand2 :: String -> HandType
findTypeHand2 xs = let a = group $ sort xs in case length a of 
  1 ->  FiveOfAKind
  2 ->  if ((length $ head a) == 2) || ((length $ last a) == 2) 
          then if(containsJ a) then upgradeHand FullHouse else FullHouse 
          else if(containsJ a) then upgradeHand FourOfAKind else FourOfAKind
  3 ->  if ((length $ a !! 0) == 3) || ((length $ a !! 1) == 3) || ((length $ a !! 2) == 3) 
          then if(containsJ a) then upgradeHand ThreeOfAKind else ThreeOfAKind 
          else if(containsJ a) 
                 then if(((a !! 0 !! 0 == 'J') && (length (a !! 0) == 1)) || ((a !! 1 !! 0 == 'J') && (length (a !! 1) == 1)) || ((a !! 2 !! 0 == 'J') && (length (a !! 2) == 1)) ) then upgradeHand TwoPair else FourOfAKind 
                 else TwoPair
  4 ->  if(containsJ a) then upgradeHand OnePair else OnePair
  5 ->  if(containsJ a) then upgradeHand HighCard else HighCard

containsJ :: [[Char]] -> Bool
containsJ [] = False
containsJ (x:xs) = if (x !! 0) == 'J' then True else containsJ xs

upgradeHand :: HandType -> HandType
upgradeHand hand = case hand of
  HighCard -> OnePair
  OnePair -> ThreeOfAKind
  TwoPair -> FullHouse
  ThreeOfAKind -> FourOfAKind
  FullHouse -> FiveOfAKind
  FourOfAKind -> FiveOfAKind
  FiveOfAKind -> FiveOfAKind
 

findTypeHand :: String -> HandType
findTypeHand xs = let a = group $ sort xs in case length a of 
  1 ->  FiveOfAKind
  2 ->  if ((length $ head a) == 2) || ((length $ last a) == 2) then FullHouse else FourOfAKind
  3 ->  if ((length $ a !! 0) == 3) || ((length $ a !! 1) == 3) || ((length $ a !! 2) == 3) then ThreeOfAKind else TwoPair
  4 ->  OnePair
  5 ->  HighCard


instance Ord HandType where
  compare HighCard x = case x of
    HighCard -> EQ
    _ -> LT
  compare OnePair x = case x of
    HighCard -> GT
    OnePair -> EQ
    _ -> LT
  compare TwoPair x = case x of
    HighCard -> GT
    OnePair -> GT
    TwoPair -> EQ
    _ -> LT
  compare ThreeOfAKind x = case x of
    HighCard -> GT
    OnePair -> GT
    TwoPair -> GT
    ThreeOfAKind -> EQ
    _ -> LT
  compare FullHouse x = case x of
    HighCard -> GT
    OnePair -> GT
    TwoPair -> GT
    ThreeOfAKind -> GT
    FullHouse -> EQ
    _ -> LT
  compare FourOfAKind x = case x of
    HighCard -> GT
    OnePair -> GT
    TwoPair -> GT
    ThreeOfAKind -> GT
    FullHouse -> GT
    FourOfAKind -> EQ
    _ -> LT
  compare FiveOfAKind x = case x of
    FiveOfAKind -> EQ
    _ -> GT
