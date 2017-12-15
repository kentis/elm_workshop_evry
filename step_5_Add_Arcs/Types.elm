module Types exposing (..)
import Mouse exposing (Position)

type Msg = 
  SelectElement Int
  | ApplyTool (Maybe Int) Position

type NodeType = 
  Place
  | Transition
  | Arc

type alias PaletteDef = 
  {
    x: Int
    , y: Int
    , height: Int
    , width: Int
    , elements: List PaletteElement
  }

type alias PaletteElement =
  { 
    id : Int
  , text: String
  , selected: Bool
  , nodeType: NodeType 
  }

type alias EditorDef = 
  {
    x: Int
    , y: Int
    , height: Int
    , width: Int
  }

type alias NodeDef = 
  {
    id: Int
    , x: Int
    , y: Int
    , nodeType: NodeType
  }

type alias ArcDef =
  {
    id : Int
    , source : Int
    , target : Int
  }

type alias Model = 
  {
    palette: PaletteDef
    , editor: EditorDef
    , nodes: List NodeDef
    , arcs: List ArcDef
    , arcStart: Maybe Int
  }
