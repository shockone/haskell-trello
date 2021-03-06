{-# LANGUAGE OverloadedStrings #-}
module Trello.Data.Card where
import Control.Applicative
import Control.Monad
import Data.Aeson           (decode)
import Data.Aeson.Parser
import Data.Aeson.Types     hiding (Error)
import Data.ByteString.Lazy (ByteString)

import Trello.ApiData
import Trello.Data

newtype CardList = CardList [Card]

parseCard :: ByteString -> Either Error Card
parseCard json = validateJson $ decode json

parseCards :: ByteString -> Either Error [Card]
parseCards json = validateJson $ decode json

instance FromJSON Card where
  parseJSON (Object o) =
    Card <$> liftM CardRef  (o .: "id")
         <*> liftM BoardRef (o .: "idBoard")
         <*> liftM ListRef  (o .: "idList")
         <*> o .: "name"
         <*> o .: "desc"
         <*> liftM (map MemberRef) (o .: "idMembers")
         <*> o .:? "due"
         <*> o .: "dateLastActivity"
         <*> o .: "closed"
         <*> o .: "shortUrl"
         <*> o .: "url"
  parseJSON _          = fail "Can't decode"
