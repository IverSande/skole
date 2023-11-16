

--map f (map g x)
--map (f g) x


--reverserer input
main = do 
  putStrLn "Hva heter du til fornavn?"
  (first : rest) <- (reverse . map toLower) <$> getLine
  putStrLn $ "Hei, " ++ (toUpper first) : rest

sumOfSquares list = [x*x | x <- list]
sumOfSquares' list = sum (map (\x -> x*x) list)

duplicate :: [a] -> [a]
duplicate [] = []
duplicate (a:as) = a:a:duplicate as


duplicate' :: [a] -> [a]
duplicate' list = do
  x <-list
	[x,x]















