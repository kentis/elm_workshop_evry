module Update exposing (update)
import Types exposing (..)
import Mouse exposing (Position)

update: Msg -> Model -> (Model, Cmd msg)
update msg model = 
  case msg of
    SelectElement id ->
      ({model | palette = (selectInPalette model.palette id)}, Cmd.none)
    ApplyTool id pos ->
        ((applyTool model id pos ), Cmd.none)

applyTool: Model -> Maybe Int -> Position -> Model
applyTool model id pos =
  let
    newElementType = List.head (List.map (\x -> x.nodeType) (List.filter (\x -> x.selected) model.palette.elements ))
    nodes = model.nodes
  in
        case newElementType of
          Just Arc ->
            case model.arcStart of
                  Just startId->
                    case id of
                        Just nodeId ->
                            {model | arcStart = Nothing, 
                            palette = (selectInPalette model.palette -1), 
                            arcs=model.arcs++[{id=(getNextId model), source=startId, target=nodeId}] } 
                        Nothing ->
                          {model | palette = (selectInPalette model.palette -1), arcStart=Nothing }
                    
                  Nothing ->
                    {model | arcStart = id}
          Just nodeType ->
            {model | palette = (selectInPalette model.palette -1), nodes=(model.nodes ++ [(newNode nodeType pos model)] )}
          Nothing ->
            model

newNode nodeType pos model = 
  let
    nextId = getNextId model
  in
    {id=nextId, nodeType = nodeType, x=pos.x-model.editor.x, y=pos.y-model.editor.y}

getNextId model = 
  case (List.maximum <| List.map (\x -> x.id ) model.nodes ++ List.map (\x -> x.id ) model.arcs) of
    Just n ->
      n+1
    Nothing ->
      1

selectInPalette palette id =
  {palette | elements=(List.map 
    (\x -> case x.id == id of 
      True ->
        {x | selected = True}
      False ->
        {x | selected = False}
    )  palette.elements)}


