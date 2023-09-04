
module Week37Exercise0 where
  import Data.Maybe
  information :: [String] -> [String] -> [Integer] -> [String]
  information personName instituteName startYear = map fromJust (filter (/=Nothing)(map parseTuple (zip3 personName instituteName startYear)))

  parseTuple :: (String, String, Integer) -> Maybe String
  parseTuple (a, b, c) = case(c > 2021) of 
    True -> Just (a ++ " is studying at " ++ b ++ " department and started in " ++ show c) 
    False -> Nothing

  












