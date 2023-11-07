{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE OverloadedLists      #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE LambdaCase           #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE TupleSections        #-}
{-# LANGUAGE StandaloneDeriving   #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE RankNTypes           #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE AllowAmbiguousTypes  #-}

module GradingRecord where

import qualified Data.Aeson as Json
import Data.Aeson (FromJSON, parseJSON, ToJSON, toJSON)
import qualified Data.Yaml as Yaml
import qualified Data.Yaml.Pretty as Pretty
import qualified Data.Map as Map
import Control.Applicative
import Control.Monad
import qualified Data.Text as Txt
import Data.List (group, sort, intercalate)
import Data.Maybe (isNothing)
import Data.Functor.Identity
import Control.Arrow ((&&&))
import qualified Data.ByteString as BS
import Text.Printf



data TaskGrade p a where
  Ungraded :: TaskGrade Maybe a
  CommentedGrade :: { getCommentedValue :: a, getComment :: Maybe Txt.Text }
       -> TaskGrade p a
deriving instance Show a => Show (TaskGrade Identity a)
deriving instance Show a => Show (TaskGrade Maybe a)

instance FromJSON a => FromJSON (TaskGrade Identity a) where
  parseJSON g =  CommentedGrade<$>parseJSON g<*>pure Nothing
             <|> Yaml.withArray "Commented"
                  (\case
                      [v, Json.String c]
                        -> CommentedGrade<$>parseJSON v<*>pure (Just c)
                      _ -> fail "Comments must come in form of 2-element arrays."
                  ) g
instance ToJSON a => ToJSON (TaskGrade Identity a) where
  toJSON (CommentedGrade v Nothing) = toJSON v
  toJSON (CommentedGrade v (Just c)) = Json.Array [toJSON v, toJSON c]

instance FromJSON a => FromJSON (TaskGrade Maybe a) where
  parseJSON Json.Null = pure Ungraded
  parseJSON g =  CommentedGrade<$>parseJSON g<*>pure Nothing
             <|> Yaml.withArray "Commented"
                  (\case
                      [v, Json.String c]
                        -> CommentedGrade<$>parseJSON v<*>pure (Just c)
                      _ -> fail "Comments must come in form of 2-element arrays."
                  ) g
instance ToJSON a => ToJSON (TaskGrade Maybe a) where
  toJSON Ungraded = Json.Null
  toJSON (CommentedGrade v Nothing) = toJSON v
  toJSON (CommentedGrade v (Just c)) = Json.Array [toJSON v, toJSON c]

newtype Subgrade = Subgrade { getSubgrade :: Double }
 deriving (Eq, Ord)
instance Show Subgrade where
  show (Subgrade g) = show g

instance FromJSON Subgrade where
  parseJSON g = Subgrade <$> (parseJSON g
                              <|> (\case {False->0; True->1})<$>parseJSON g)
instance ToJSON Subgrade where
  toJSON (Subgrade g) = toJSON g

type Assessments a p = Map.Map String (a p)

class Assessment a where
  assessmentJSONable
    :: ( FromJSON (TaskGrade p Bool), FromJSON (TaskGrade p Subgrade)
       , ToJSON (TaskGrade p Bool), ToJSON (TaskGrade p Subgrade)
       ) => ((FromJSON (a p), ToJSON (a p)) => r)
        -> r
  emptyAssessment :: a Maybe
  brokenArchiveAssessment :: a Maybe

