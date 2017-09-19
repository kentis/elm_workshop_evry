module Pallette exposing (pallette)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)

pallette model =
    ul [Html.Attributes.style [ ("position", "absolute")
                              , ("left", ((toString model.pallette.x)++"px"))
                              , ("top", ((toString model.pallette.y)++"px"))
                              , ("width", ((toString model.pallette.width)++"px"))
                              , ("height", ((toString model.pallette.height)++"px"))
                              , ("margin", "0")
                              , ("padding", "0")
                              , ("text-align", "left")
                              , ("border-right","solid")]
       ]
       (List.map renderElement model.pallette.elements)

renderElement : PalletteElement -> Html Msg
renderElement element =
    li [style (getElementStyle element), onClick (SelectElement element.id) ] [ text element.text ]

getElementStyle : PalletteElement -> List (String, String)
getElementStyle element =
    [
        ("background-color", case element.selected of
                    True ->
                        "gray"
                    _ ->
                        "white"
        )
    ]
