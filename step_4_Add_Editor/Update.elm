module Update exposing (update)
import Types exposing (..)
import Mouse exposing (Position)

update msg model = 
  case msg of
    SelectElement id ->
      ({model | pallette = (selectInPallette model.pallette id)}, Cmd.none)
    ApplyTool pos ->
        ((applyTool model pos ), Cmd.none)

applyTool model pos =
  let
    newElementType = List.head (List.map (\x -> x.nodeType) (List.filter (\x -> x.selected) model.pallette.elements ))
    nodes = model.nodes
  in
        case newElementType of
          Just nodeType ->
            {model | pallette = (selectInPallette model.pallette -1), nodes=(model.nodes ++ [(newNode nodeType pos model)] )}
          Nothing ->
            model

newNode nodeType pos model = 
  let
    nextId = 
      case (List.maximum <| List.map (\x -> x.id ) model.nodes) of
        Just n ->
          n+1
        Nothing ->
          1
  in
    {id=nextId, nodeType = nodeType, x=pos.x-model.editor.x, y=pos.y-model.editor.y}
    
selectInPallette pallette id =
  {pallette | elements=(List.map 
    (\x -> case x.id == id of 
      True ->
        {x | selected = True}
      False ->
        {x | selected = False}
    )  pallette.elements)}


