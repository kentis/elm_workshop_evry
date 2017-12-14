module Types exposing (..)

type Msg = 
  SelectElement Int

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
  }

type alias Model = 
  {
    palette: PaletteDef
  }
