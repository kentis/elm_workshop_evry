module Main exposing (..)
import Html exposing (programWithFlags, h1, text)

main =
    Html.program { view = view, init = init, update = update, subscriptions = subscriptions }

init = ([], Cmd.none)

update msg model = (model, Cmd.none)

subscriptions model = Sub.none

view model = 
  h1 [][text "Hello Elm"]  
