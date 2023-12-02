

readTheFile :: IO String
readTheFile = do 
  a <- readFile "files/des2.txt"
  putStrLn $ show $ sum $ map (\x -> doThing2 x 0 0 0) (map (filter (/=";")) $ map (\x -> parseLine (x) []) $ lines a)
  return "yup"

parseLine :: String -> String -> [String]
parseLine [] acc = [acc]
parseLine (x:xs) acc = if (x == ':' || x == ',')
  then [acc] ++ (parseLine xs []) 
  else if (x == ';') 
    then [acc] ++ [";"] ++ (parseLine xs [])
    else parseLine xs (acc ++ [x])

doThing :: [String] -> Int -> Int
doThing [] gameNum = gameNum
doThing (x:xs) gameNum = if (head (words x) == "Game") 
  then doThing xs (read $ last (words x))
  else case (last (words x)) of
    "red" -> if((read $ head (words x)) > 12) then 0 else doThing xs gameNum
    "green" ->if((read $ head (words x)) > 13) then 0 else doThing xs gameNum
    "blue" -> if((read $ head (words x)) > 14) then 0 else doThing xs gameNum



doThing2 :: [String] -> Int -> Int -> Int -> Int
doThing2 [] redMax greenMax blueMax = redMax * greenMax * blueMax
doThing2 (x:xs) rM gM bM = if (head (words x) == "Game") 
  then doThing2 xs 0 0 0
  else case (last (words x)) of
    "red" -> if((read $ head (words x)) > rM) then doThing2 xs (read $ head (words x)) gM bM else doThing2 xs rM gM bM
    "green" ->if((read $ head (words x)) > gM) then doThing2 xs rM (read $ head (words x)) bM else doThing2 xs rM gM bM
    "blue" -> if((read $ head (words x)) > bM) then doThing2 xs rM gM (read $ head (words x)) else doThing2 xs rM gM bM








