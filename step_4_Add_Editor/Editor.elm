module Editor exposing (editor)
import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html.Events exposing (..)
import Mouse exposing (position, Position)
import Json.Decode as Decode
import Types exposing (..)


editor : Model -> Html.Html Msg
editor model =
    svg [
        width (toString model.editor.width)
        , height (toString model.editor.height)
        , Svg.Attributes.style (" position: absolute; left: "++ (toString model.editor.x) ++"px; top:"++(toString model.editor.y) ++"px;   ")
        , viewBox "0 0 1200 1000"
        , onEditorClick ]
        (List.concat (List.map renderNode model.nodes))

renderNode: NodeDef -> List (Svg.Svg Msg)
renderNode node =
    case node.nodeType of
        Place ->
            place node
        Transition ->
            transition node

transition : NodeDef -> List (Svg.Svg Msg)
transition trans =
    [rect [
              x (toString trans.x)
            , y (toString trans.y)
            , width "10px"
            , height "10px"
            , fill "white"
            , stroke "black"
            , strokeWidth "1"] []
    ]


place : NodeDef -> List (Svg.Svg Msg)
place pl =
    [
        circle [  cx (toString pl.x)
                , cy (toString pl.y)
                , r "5px"
                , stroke "black"
                , strokeWidth "1"
                , fillOpacity "0"] []
    ]
    


onEditorClick:  Html.Attribute Msg
onEditorClick  =
    onWithOptions "click" {stopPropagation=True, preventDefault=True}  (Decode.map (ApplyTool) Mouse.position)



