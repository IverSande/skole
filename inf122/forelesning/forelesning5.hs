import Data.Char


pyt :: [(Integer, Integer, Integer)]
pyt = [(a, b, c) | a <- [1..200], b <- [a..200], c <-[b..600], a^2 + b^2 == c^2]

numbers :: [Integer]
numbers = [0,1..]

primes :: [Integer]
primes = 2:filter isPrime[3..]

isPrime :: Integer -> Bool
isPrime x = all (\y -> mod x y /= 0) (takeWhile (\y -> y*y <= x)primes)

isPrimeComp :: Integer -> Bool
isPrimeComp x = all ((/= 0) . mod x) (takeWhile (\y -> y*y <= x)primes)

interleave :: [a] -> [a] -> [a]
interleave list1 list2 = concat $ zipWith (\x y -> [x,y]) list1 list2

interleaveShorter :: [a] -> [a] -> [a]
interleaveShorter = (\a b -> concat $ zipWith (\x y -> [x,y]) a b)

--Dont do this very imperative uses a lot of power due to going through entire list for each element
stringToUpper :: String -> String
stringToUpper str = [toUpper (str !! i) | i <- [0.. length str -1]]

stringToUpperFunctional :: String -> String
stringToUpperFunctional str = [ toUpper a | a <- str]

stringToUpperFunctionalMap :: String -> String
stringToUpperFunctionalMap = map toUpper





