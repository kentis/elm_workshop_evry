module Types exposing (..)
import Mouse exposing (Position)

type Msg = 
  SelectElement Int
  | ApplyTool Position

type NodeType = 
  Place
  | Transition

type alias PalletteDef = 
  {
    x: Int
    , y: Int
    , height: Int
    , width: Int
    , elements: List PalletteElement
  }

type alias PalletteElement =
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
    pallette: PalletteDef
    , editor: EditorDef
    , nodes: List NodeDef
  }
