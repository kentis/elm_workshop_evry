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
        , onEditorClick Nothing ]
        ([ 
          marker [id "arrow", markerWidth "10", markerHeight "10", refX "8", refY "3", orient "auto", markerUnits "strokeWidth"] [
            Svg.path [d "M0,0 L0,6 L9,3 z", fill "black"] []
          ]
        ] ++ (List.concat (List.map renderNode model.nodes))
          ++ (List.concat (List.map (renderArc  model model.nodes) model.arcs) )
        )

renderArc : Model -> List NodeDef -> ArcDef -> List (Svg.Svg Msg)
renderArc model nodes arc =
    let
      startNode = case (List.filter (\x -> x.id == arc.source) nodes) of
                      n :: rest ->
                        Just n
                      option2 ->
                        Nothing
      targetNode = case (List.filter (\x -> x.id == arc.target) nodes) of
                      n :: rest ->
                        Just n
                      option2 ->
                        Nothing
    in
        case startNode of
             Just sn ->
               case targetNode of
                 Just tn ->
                   [
                     --line [x1 (toString sn.x), y1 (toString sn.y),  x2 (toString tn.x), y2 (toString tn.y), Svg.Attributes.style "stroke:rgb(255,0,0);stroke-width:2", markerEnd "url(#arrow)", onArcClick arc.id] []    
                     Svg.path [d (renderPath model sn tn), stroke "black", strokeWidth "1", fill "none", Svg.Attributes.style "stroke:rgb(0,0,0);stroke-width:1", markerEnd "url(#arrow)" ][]
                   ]
                 Nothing ->
                    Debug.crash "No target node"
             Nothing ->
                Debug.crash "No sorce node"

renderPath: Model -> NodeDef -> NodeDef -> String
renderPath model startNode endNode  =
    "M"
    ++ (toString startNode.x) ++ " " ++ (toString startNode.y) 
    ++" L"++(toString endNode.x) ++ " " ++(toString endNode.y)
    ++ "M"


renderNode: NodeDef -> List (Svg.Svg Msg)
renderNode node =
    case node.nodeType of
        Place ->
            place node
        Transition ->
            transition node
        Arc ->
            Debug.crash "Arc in the Node list!"

transition : NodeDef -> List (Svg.Svg Msg)
transition trans =
    [rect [
              x (toString trans.x)
            , y (toString trans.y)
            , width "10px"
            , height "10px"
            , fill "white"
            , stroke "black"
            , strokeWidth "1"
            , onEditorClick (Just trans.id)] []
    ]


place : NodeDef -> List (Svg.Svg Msg)
place pl =
    [
        circle [  cx (toString pl.x)
                , cy (toString pl.y)
                , r "5px"
                , stroke "black"
                , strokeWidth "1"
                , fillOpacity "0"
                , onEditorClick (Just pl.id)] []
    ]
    


onEditorClick: Maybe Int -> Html.Attribute Msg
onEditorClick id =
    onWithOptions "click" {stopPropagation=True, preventDefault=True}  (Decode.map (ApplyTool id) Mouse.position)



