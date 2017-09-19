module Main exposing (..)
import Html exposing (programWithFlags, h1, text, div)
import Pallette exposing (pallette)
import Types exposing (..)
import Update exposing(update)

main =
    Html.program { view = view, init = init, update = update, subscriptions = subscriptions }

init = ({ 
  pallette = {
    x=10
    , y=10
    , height = 500
    , width = 100
    , elements = [
      {
        id = 1
        , text = "Place"
        , selected = False    
      }
      ,{
        id = 2
        , text = "Transition"
        , selected = False    
      }
    ]
  } 
 }, Cmd.none)

subscriptions model = Sub.none

view model = 
  div [][
       pallette model
   ]  
