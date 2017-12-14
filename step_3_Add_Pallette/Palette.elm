module Palette exposing (palette)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)

palette model =
    ul [Html.Attributes.style [ ("position", "absolute")
                              , ("left", ((toString model.palette.x)++"px"))
                              , ("top", ((toString model.palette.y)++"px"))
                              , ("width", ((toString model.palette.width)++"px"))
                              , ("height", ((toString model.palette.height)++"px"))
                              , ("margin", "0")
                              , ("padding", "0")
                              , ("text-align", "left")
                              , ("border-right","solid")]
       ]
       (List.map renderElement model.palette.elements)

renderElement : PaletteElement -> Html Msg
renderElement element =
    li [style (getElementStyle element), onClick (SelectElement element.id) ] [ text element.text ]

getElementStyle : PaletteElement -> List (String, String)
getElementStyle element =
    [
        ("background-color", case element.selected of
                    True ->
                        "gray"
                    _ ->
                        "white"
        )
    ]
