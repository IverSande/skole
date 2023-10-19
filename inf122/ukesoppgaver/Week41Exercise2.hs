module Week41Exercise2 where

import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe

data Expr variable
  = Var variable
  | Lit Bool
  | And (Expr variable) (Expr variable)
  | Or (Expr variable) (Expr variable)
  deriving (Eq, Show)
  

eval :: (Ord variable) => Expr variable -> Map variable Bool -> Maybe Bool
eval exprVar mapVar = case exprVar of
  Lit a -> Just a
  And a b -> if(isNothing (eval a mapVar) || isNothing (eval b mapVar)) then Nothing else Just(fromJust(eval a mapVar) && fromJust(eval b mapVar))
  Or a b -> if(isNothing (eval a mapVar) || isNothing (eval b mapVar)) then Nothing else Just(fromJust(eval a mapVar) || fromJust(eval b mapVar))
  Var a -> Map.lookup a mapVar







