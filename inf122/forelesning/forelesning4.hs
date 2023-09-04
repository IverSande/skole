
hasNoE :: String -> Bool
hasNoE word = not (elem 'e' word)

removee :: String -> String
removee sentence = unwords (filter hasNoE (words sentence))

zipIndex :: String -> [(Integer, Char)]
zipIndex input = zip [0..] input

rushAlbumYears :: [Integer]
rushAlbumYears = filter (/=1979) [1976..1982]

rushAlbumTitles = [ "2112", "A Farewell to Kings", "Hemispheres", "Permanent Waves", "Moving Picutre", "Signals"]

rushAlbums :: [(Integer, String)]
rushAlbums = zip rushAlbumYears rushAlbumTitles

displayAlbum :: String -> Integer -> String -> String
displayAlbum band year title = "In " ++ show year ++ " " ++ band ++ " released " ++ title




