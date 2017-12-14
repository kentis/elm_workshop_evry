module Types exposing (..)
import Mouse exposing (Position)

type Msg = 
  SelectElement Int
  | ApplyTool Position

type NodeType = 
  Place
  | Transition

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


type alias Model = 
  {
    palette: PaletteDef
    , editor: EditorDef
    , nodes: List NodeDef
  }
