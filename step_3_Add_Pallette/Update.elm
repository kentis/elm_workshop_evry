module Update exposing (update)
import Types exposing (..)

update msg model = 
  case msg of
    SelectElement id ->
      ({model | pallette = (selectInPallette model.pallette id)}, Cmd.none)


selectInPallette pallette id =
  {pallette | elements=(List.map 
    (\x -> case x.id == id of 
      True ->
        {x | selected = True}
      False ->
        {x | selected = False}
    )  pallette.elements)}


