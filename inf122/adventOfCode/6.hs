import Debug.Trace

main =
  readFile "files/des6.txt" >>= \x ->
  let y = zip (map read $ tail $ words $ head $ lines x) (map read $ tail $ words $ last $ lines x) :: [(Int, Int)] in
  putStrLn $ show $ foldr (*) 1 $ map (\q -> computeTimes q 0) y 

pain = 
  readFile "files/des6.txt" >>= \x -> 
  let p = (tail $ words $ head $ lines x) in
  let o = (tail $ words $ last $ lines x) in
  putStrLn $ show $ computeTimes2 (read $ concat p, read $ concat o) 0
 -- putStrLn $ show $ foldr (*) 1 $ map(\z -> computeTimes z 0) p


computeTimes2 :: (Int, Int) -> Int -> Int
computeTimes2 (a,b) c | trace (show (a,b) ++ " : " ++ show c) False = undefined
computeTimes2 (a,b) c = if c == a then 1 else
  if (c+100000) < a && ((doTheThing (a,b,(c+100000)) &&  doTheThing (a,b,c)) || (doTheThing (a,b, (c+100000)) == False && doTheThing (a,b,c) == False))
    then if doTheThing (a,b,(c+100000)) then 100000 + computeTimes2 (a,b) (c+100000) else computeTimes2 (a,b) (c+100000)
    else if (c+10000) < a && ((doTheThing (a,b,(c+10000)) && doTheThing (a,b,c)) ||  (doTheThing (a,b, (c+10000)) == False && doTheThing (a,b,c) == False))
    then if doTheThing (a,b,(c+10000)) then 10000 + computeTimes2 (a,b) (c+10000) else computeTimes2 (a,b) (c+10000)
    else if (c+1000) < a && ((doTheThing (a,b,(c+1000)) && doTheThing (a,b,c)) ||  (doTheThing (a,b, (c+1000)) == False && doTheThing (a,b,c) == False))
    then if doTheThing (a,b,(c+1000)) then 1000 + computeTimes2 (a,b) (c+1000) else computeTimes2 (a,b) (c+1000)
    else if (c+100) < a && ((doTheThing (a,b,(c+100)) && doTheThing (a,b,c)) ||  (doTheThing (a,b, (c+100)) == False && doTheThing (a,b,c) == False))
    then if doTheThing (a,b,(c+100)) then 100 + computeTimes2 (a,b) (c+100) else computeTimes2 (a,b) (c+100)
    else if (c+10) < a && ((doTheThing (a,b,(c+10)) && doTheThing (a,b,c)) ||  (doTheThing (a,b, (c+10)) == False && doTheThing (a,b,c) == False))
    then if doTheThing (a,b,(c+10)) then 10 + computeTimes2 (a,b) (c+10) else computeTimes2 (a,b) (c+10)
    else if (c+1) < a && ((doTheThing (a,b,(c+1)) && doTheThing (a,b,c)) ||  (doTheThing (a,b, (c+1)) == False && doTheThing (a,b,c) == False))
    then if doTheThing (a,b,(c+1)) then 1 + computeTimes2 (a,b) (c+1) else computeTimes2 (a,b) (c+1)
        else computeTimes2 (a,b) (c+1)

doTheThing :: (Int, Int, Int) -> Bool
--doTheThing (a,b,c) | trace (show (a,b,c)) False = undefined
doTheThing (a,b,c) = if ((a - c) * c) > b && c < a
  then True
  else False

computeTimes :: (Int, Int) -> Int -> Int
computeTimes (a,b) c = if c == a then 0 else
  if doTheThing (a,b,c)
    then 1 + computeTimes (a,b) (c+1)
    else computeTimes (a,b) (c+1)


