module Update exposing (update)
import Types exposing (..)

update msg model = 
  case msg of
    SelectElement id ->
      ({model | palette = (selectInPalette model.palette id)}, Cmd.none)


selectInPalette palette id =
  {palette | elements=(List.map 
    (\x -> case x.id == id of 
      True ->
        {x | selected = True}
      False ->
        {x | selected = False}
    )  palette.elements)}


