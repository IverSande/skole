import Text.Read

combineNames :: (String, String, Integer) -> String
combineNames (firstName, lastName, yearOfBirth) = firstName ++ " " ++ lastName

normalisere :: (Double, Double, Double) -> (Double, Double, Double)
normalisere (x, y, z) = (x/norm, y/norm, z/norm) 
  where
    norm :: Double
    norm = sqrt(x^2 + y^2 + z^2)

handleInput :: Maybe (Double,Double,Double) -> IO ()
handleInput Nothing 
  = do
    putStrLn "Please enter a valid vector"
    main
handleInput (Just vector)
  = do
    let result = normalisere vector
    putStrLn $ "Normalised vector: " ++ show result
main = do
  putStrLn "Enter a three dimensional vector : "
  input <- getLine
  handleInput (readMaybe input)

maybe :: b -> (a -> b) -> Maybe a -> b
maybe _ f (Just value) = f value
maybe def f Nothing = def












