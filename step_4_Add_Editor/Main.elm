module Main exposing (..)
import Html exposing (programWithFlags, h1, text, div)
import Pallette exposing (pallette)
import Types exposing (..)
import Update exposing(update)
import Editor exposing(editor)
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
        , nodeType = Place 
      }
      ,{
        id = 2
        , text = "Transition"
        , selected = False    
        , nodeType = Transition 
      }
    ]
  }
  , editor = {
    x=110
    , y=10
    , height = 1000
    , width = 1200
  } 
  , nodes = []
 }, Cmd.none)

subscriptions model = Sub.none

view model = 
  div [][
       pallette model
       ,editor model
   ]  
