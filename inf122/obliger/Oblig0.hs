module Oblig0 where

import qualified Data.Set as Set
import Data.Maybe
import Data.Tuple
import GHC.Float
import Data.List
import Data.Function

type Key = [(Char,Char)]
type FrequencyTable = [(Char,Double)]
type Alphabet = String
type Dictionary = Set.Set String

encode :: Key -> String -> String
encode _ [] = []
encode k (x:xs) = (fromMaybe x $ lookup x k) : encode k xs

decode :: Key -> String -> String
decode k s = encode (map swap k) s  

count :: String -> FrequencyTable
count s = countHelper (sort s) (length s) 1

countHelper :: String -> Int -> Int -> FrequencyTable
countHelper [x] length counter = [(x, int2Double counter / int2Double length)] 
countHelper (x:y:xs) length counter = if x /= y 
                                        then [(x, int2Double counter / int2Double length)] ++ countHelper (y:xs) length 1 
                                        else countHelper (y:xs) length (counter+1)

caesar :: Alphabet -> Integer -> Key
caesar alphabet shift = zip alphabet (caesarHelper alphabet shift)

caesarHelper :: Alphabet -> Integer -> Alphabet
caesarHelper a i = snd(splitAt (fromIntegral q) a) ++ fst(splitAt (fromIntegral q) a)
  where q = mod i (toInteger $ length a)

loadFrequencyTable :: FilePath -> IO FrequencyTable
loadFrequencyTable file = do
                            a <- readFile file
                            return $ count a

initialGuess :: FrequencyTable -> FrequencyTable -> Key
initialGuess model observation = zipWith (\(x,b) (y,c) -> (x,y)) (sortBy (flip compare `on` snd) model) (sortBy (flip compare `on` snd) observation)

chiSquared :: FrequencyTable -> FrequencyTable -> Double
chiSquared model observation = chiHelper model observation (Set.toList( Set.fromList ((map (\(x, y) -> x) model) ++ (map (\(x,y) -> x) observation))))

chiHelper :: FrequencyTable -> FrequencyTable -> [Char] -> Double
chiHelper model observation [c] = chiHelperHelper model observation c
chiHelper model observation (c:cs) = chiHelperHelper model observation c + chiHelper model observation cs

chiHelperHelper :: FrequencyTable -> FrequencyTable -> Char -> Double
chiHelperHelper model observation c = if (isJust $ lookup c model) && (isJust $ lookup c observation)
                                       then ((((fromJust (lookup c observation)) - (fromJust  (lookup c model)))**2) / fromJust (lookup c model))
                                       else 
                                         if (isJust $ lookup c model) 
                                           then ((((1/10000) - fromJust (lookup c model))**2) / fromJust (lookup c model))
                                           else ((((fromJust (lookup c observation)) - (1/10000))**2) / (1/10000))

neighbourKeys :: Key -> [Key]
neighbourKeys key = neighbourKeysMid key key 0

neighbourKeysMid :: Key -> Key -> Int -> [Key]
neighbourKeysMid _ [x] _ = []
neighbourKeysMid key (x:xs) a = (headKey : neighbourKeysHelper 0 (head tailKey) tailKey) ++ neighbourKeysMid key xs (a+1)
  where headKey = fst(splitAt a key); tailKey = snd(splitAt a key) 

neighbourKeysHelper :: Int -> (Char,Char) -> Key -> [Key] 
neighbourKeysHelper a (b,c) fullKey = if((b,c)== last fullKey) then [] else neighbourKeysHelperHelper (b,c) fullKey a ++ if(a==length fullKey - 1) then [] else neighbourKeysHelper (a+1) (b,c) fullKey

neighbourKeysHelperHelper :: (Char,Char) -> Key -> Int -> [Key]
neighbourKeysHelperHelper (c,b) fullKey a = 
    if((c,b) == last fullKey || (c,b) == head (snd(splitAt a fullKey))) 
    then []  
    else [swapEntries (c,b) (head (snd(splitAt a fullKey))) fullKey] 

swapEntries ::  Eq a => (a,a) -> (a,a) -> [(a,a)] -> [(a,a)]
swapEntries (c1, e1) (c2, e2) [k] = swapEntriesHelper (c1, e1) (c2, e2) k
swapEntries (c1, e1) (c2, e2) (key:keys) = swapEntriesHelper (c1, e1) (c2, e2) key ++ swapEntries (c1,e1) (c2,e2) keys

swapEntriesHelper :: Eq a => (a,a) -> (a,a) -> (a,a) -> [(a,a)]
swapEntriesHelper (c1, e1) (c2, e2) (c3, e3) = if  c3==c1 then [(c1,e2)] else if c3==c2 then [(c2,e1)] else [(c3,e3)]

greedy :: FrequencyTable -> String -> Key -> Key
greedy model cipherText initKey = undefined

loadDictionary :: FilePath -> IO Dictionary
loadDictionary fil = undefined

countValidWords :: Dictionary -> String -> Integer
countValidWords dict = undefined

greedyDict :: Dictionary -> String -> Key -> Key
greedyDict dict cipherText initKey = undefined

