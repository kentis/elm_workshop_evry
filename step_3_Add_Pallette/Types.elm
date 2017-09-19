module Types exposing (..)

type Msg = 
  SelectElement Int

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
  }

type alias Model = 
  {
    pallette: PalletteDef
  }
