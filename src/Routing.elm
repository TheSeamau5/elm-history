module Routing where

-- This module is only included here for the examples
-- elm-history does not depend on this module

import String exposing (startsWith, dropLeft, length)

type alias Route a = String -> a

type alias Router a = (String, Route a)


match : List (Router a) -> Route a -> Route a
match routers defaultRoute url = case routers of
  [] -> defaultRoute url
  (prefix, route) :: rs ->
    if
      prefix == "" || prefix == "/"
    then
      if
        url == prefix
      then
        route url
      else
        match rs defaultRoute url
    else
      case matchPrefix prefix url of
        Just value -> route value
        Nothing    -> match rs defaultRoute url

matchPrefix : String -> String -> Maybe String
matchPrefix prefix string =
  if
    startsWith prefix string
  then
    Just <| dropLeft (length prefix) string
  else
    Nothing


(:->) : String -> Route a -> Router a
(:->) = (,)
