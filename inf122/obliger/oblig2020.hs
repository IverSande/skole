



main = interact $ parser

parser :: String -> String
parser a = 
  case (a) of
    "e" -> "This is it"
    ['y'] -> "still it"
    _ -> "nop"





