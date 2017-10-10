# Elm SVG editor tutorial 

## Outline


In this tutorial we will create a simple graph net editor using ELM and SVG. We will be able to place to types of nodes on a canvas and draw arcs between them. The editor will be useable as a very simple Petri Net editor.

TODO: insert image of application with a simple petri net drawn?


1. Install Elm and create a new application
3. Add palette
4. Add Editor


### Bonus tasks

1. Add arcs
2. Dragging nodes
3. Resize nodes



## 1. Install Elm and create a new application
1. Install elm:
Either:

choose an installer at: https://guide.elm-lang.org/install.html

Or: 
Install using node package manager
```
$ npm install -g elm
``` 


Create a new folder. Inside the folder create a file called elm-package.json. Edit elm-package.json to include the following:

```json
{
    "version": "0.0.1",
    "summary": "A very simple petri net editor",
    "license": "BSD3",
    "repository": "https://github.com/example/example.git",
    "source-directories": [
        "."
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "5.0.0 <= v < 6.0.0",
        "elm-lang/html": "2.0.0 <= v < 3.0.0"
    },
    "elm-version": "0.18.0 <= v < 0.19.0"
}
```

This files tells the elm compiler and other tools that the elm files reside in the current directory and that the application uses the core and html packages.

Create a new file in the same directory called Main.elm with the following content:

```elm
module Main exposing (..)
import Html exposing (programWithFlags, h1, text)

main =
    Html.program { view = view, init = init, update = update, subscriptions = subscriptions }

init = ([], Cmd.none)

update msg model = (model, Cmd.none)

subscriptions model = Sub.none

view model =
  h1 [][text "Hello Elm"]
```

This is a Elm module that contains five functions.

- main: the main functions starts the Elm application by calling Html.program with a record which sends basic lifecycle functions to the framework.

- view: the view function is used to render the view. This function is called each time the application is updated with the current model as input parameter. In this example the view conists of a single h1 tag with no parameters and which contains the text "Hello Elm"

- init: the init function is used to provide the inital value for the model and give an inital command. In this case it contains an empty List and the none-command.

- update: The update function gets a message and a model as input and is expected to update return an updated model based on the message. This new  model is then passed to the view function.

- subscriptions: The subscriptions method allows subscribing to events. For now, we have no subscriptions.

### Verification

In the directory of the application, run the command `elm-reactor`

Then go to <http://localhost:8000> and click on Main.elm. The applicatino should now download dependencies and compile. After a while, you should se the text "Hello Elm" in the browser.

## 3. Add Pallette

The pallette allows the user to chose which element he should be added. In our Petri Net example we hve two node types: places and transitions. Furthermore, we have arcs to bind places and transistions together.

- Msg which is a union type that, for now, has a single element "SelectElement Int". This type includes the messages that are used in the pallication.
- PalletteDef which is a record type with the following elelements
  - x, an integer that says where on the x-axis the pallette should be placed
  - y, an integer that syas where on the y-axis the pallette should be placed
  - height and width, integers that define the height and width of the pallette
  - elements: a list of PalletteElement records

- PalletteElement which is a record type that is used to descibe the indivual elements of the pallette and contains
  - id: And integer that is used to uniquely identify the elelement
  - text: the displayed text whwn this element is rendered
  - selected: a flag indicating wether the current element is selectedd.

- Model: is a record type which is used as the model for our application. For now, the model contains a single element:
  - pallette, a PalletteDef which is the definition of the pallette to be used in the application.

<details>
<summary>Example</summary>
<pre><code class="code highlight js-syntax-highlight elm dark" lang="elm">
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
</pre></code>

</details>


<!-- This created a single Union type called Msg and several record types. The Msg union type contains a single element SelectElement which is tagged with an Int. This type is used to send messages to the update function based on events such as from the UI.

The next type, which is a record type, named PalletteDef is the definition of a pallette. It contains an x and y that is used to position the pallette as well as the height and width of the pallette. Finally the record contains a list og PalletteElements called elements.

The PalletteElement type is defined -->

We also create a new module called Pallette in the  Pallette.elm. This module wil be responsible for rendering the pallette. The module should expose a function with the following signature ```pallette: Model -> Html Msg``` which is responsible for rendering a pallette. The pallette should be rendered a list of pallette elements wich is absolutely positoned according to the pallette element in the model. Each pallette element should be rendered as an element in the list representing the pallette. Each element sould be selcteable, which means that there should be som indicaition, such as a background color change, of wether an element is selected. Furtermore, cliks on a pallette elements should send a SelectElement message with the id of the element that has been clicked.

<details>
<summary>Example</summary>

<pre><code lang="elm">
module Pallette exposing (pallette)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)

pallette model =
    ul [Html.Attributes.style [ ("position", "absolute")
                              , ("left", ((toString model.pallette.x)++"px"))
                              , ("top", ((toString model.pallette.y)++"px"))
                              , ("width", ((toString model.pallette.width)++"px"))
                              , ("height", ((toString model.pallette.height)++"px"))
                              , ("margin", "0")
                              , ("padding", "0")
                              , ("text-align", "left")
                              , ("border-right","solid")]
       ]
       (List.map renderElement model.pallette.elements)

renderElement : PalletteElement -> Html Msg
renderElement element =
    li [style (getElementStyle element), onClick (SelectElement element.id) ] [ text element.text ]

getElementStyle : PalletteElement -> List (String, String)
getElementStyle element =
    [
        ("background-color", case element.selected of
                    True ->
                        "gray"
                    _ ->
                        "white"
        )
    ]
</pre></code>

</details>

<!-- This creates the module Palette that exposes the function pallette. The pallette function creates a ul Html element that contains one item for each pallette element from the model. This is achieved by using the List.map function in line XX that calls the renderElement function on each item in the list given by model.pallette.elements and retuns a list of the results of the renderElement function. -->

We also need a module called Update that will exposes the update method that is sent to the Elm framework in the main function. The update function will enable us to select palette elements. The update function, which has the signature
`update: Msg -> Model -> (Model, Cmd)` should recognize the SelectElement message and change the model to mark the approriate element as selected.

<details>
<summary>Example</summary>

```elm

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

```

</details>

<!-- The update function contails a switch statement over the Msg type which, for now, only contains the SelectElement value. This will be expanded later, however, for now, the case statement in the update function only hase a single case which selects a pallette element. To do this we use a syntactic trick where we create a new model by taking all the fields in the model except from the pallette which is generated by the selectInPallette function. This dunction uses the same syntactic trick together with the List.map function to select the element which id is given as a paramter to the function. -->

Finally, we the Main module should be modified by adding a pallette and a couple of elements to the initial model. Furthermore, the view function should be modifiedd so that it call the pallette function to render the pallette.

<details>
<summary>Example</summary>

```elm

module Main exposing (..)
import Html exposing (programWithFlags, h1, text, div)
import Pallette exposing (pallette)
import Types exposing (..)
import Update exposing(update)

main =
    Html.program { view = view, init = init, update = update, subscriptions = subscriptions }

init = ({ 
  pallette = {
    x=10
    , y=10
    , height = 500
    , width = 100
    , elements = [
      {
        id = 1
        , text = "Place"
        , selected = False
      }
      ,{
        id = 2
        , text = "Transition"
        , selected = False
      }
    ]
  }
 }, Cmd.none)

subscriptions model = Sub.none

view model =
  div [][
       pallette model
   ]

```

</details>
<!-- 
The main function is mostly the same as before except that the update function now comes from the Update module. The init function is expanded to support the new Model type from the Types module. Finally we have have changed the view function so that it now creates a div whose content is given by the pallette function from the Pallette moule. -->


### Verification

Repeat the verification steps from step 3. You should now be able to see the palette and select elements in it. 

## 4. Add Editor

In this section , we vill create the editor where we will draw elements from the palette. This first step is to alter the Types module so that the model knows about the editor and the elements that should be drawn on it and so that events from the editor can be handled.

<details>
  <summary>Example</summary>

```elm

module Types exposing (..)
import Mouse exposing (Position)

type Msg = 
  SelectElement Int
  | ApplyTool Int Position
  
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

type NodeType = 
  Place
  | Transition

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
```

</details>

<!-- Firstly we import Position from the Mouse module. This is used when we modify the Msg type to also include an ApplyTool element which takes an Position which reflects where on the editor the event eminates from. We also add a nodetype element to the PalletElement record. This element has the type NodeType which we define to be a union type with two values: Place and Transition. This is used to determine which type of node will be created based on the selected element in the pallette.

Next, we create the EditorDef and NodeDef types to define the editor and the nodes that should be shown in the editor. The EditorDef type contains the position of the editor and its dimensions while the NodeDef type inclides the id, type and positions of each node. Finaly, we modify the model type to include a field for the editor defintion and a list of nodes. -->

Now that we have the required types in place, we now need to create a new module to draw the editor. The module should expose a single method with the following signature: `editor : Model -> Html.Html Msg`. It should create a SVG canvas, allow the user to place elements selected from the palette on the canvas and, then draw nodes and arcs on the canvas.

<details>
<summary>Eksempel</summary>

```elm

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
        , onEditorClick ]
        (List.concat (List.map renderNode model.nodes))

renderNode: NodeDef -> List (Svg.Svg Msg)
renderNode node =
    case node.nodeType of
        Place ->
            place node
        Transition ->
            transition node

transition : NodeDef -> List (Svg.Svg Msg)
transition trans =
    [rect [
              x (toString trans.x)
            , y (toString trans.y)
            , width "10px"
            , height "10px"
            , fill "white"
            , stroke "black"
            , strokeWidth "1"] []
    ]


place : NodeDef -> List (Svg.Svg Msg)
place pl =
    [
        circle [  cx (toString pl.x)
                , cy (toString pl.y)
                , r "5px"
                , stroke "black"
                , strokeWidth "1"
                , fillOpacity "0"] []
    ]

onEditorClick:  Html.Attribute Msg
onEditorClick  =
    onWithOptions "click" {stopPropagation=True, preventDefault=True}  (Decode.map (ApplyTool) Mouse.position)

```

</details>

<!-- The module uses several libraries as  well as the Types module. It exposes only a single function editor. The editor function takes a Model as an argument end returns a list of html elements. Specifically, the function creates an svg area and then draws each node by calling the renderNode function for each node in the list of nodes in the model.

The renderNode function uses the nodeType element in NodeDef to figure out how to draw each node and returns the result of the transition or place methods. The place and transition methods return a rectangle or circle respectively. These shapes are then placed on the svg area by the editor method by incluing the list og shapes as the second argument to the svg function. In the first of the two lists that are the arguments to the svg function we also call the onEditorClick function. This function returns an event handler that handles clicks on the editor. This handeler sends the ApplyTool message to the update function with the position of the mouse as argument. This message is used to add nodes to the editor. -->

We also need to make some changes to the Update module. In this module we expand the case-of statement in the update method to also handle the ApplyTool message. When the message has the applytool value the applyTool method is called with the model and the position that comes as an argument to the ApplyTool message as arguments. The applyTool method first fetches the type of the selected tool from the palette and also the list of nodes from the model. These data are used in a case statement that, if a nodeType is selected, alters the model record by setting the selected element of the palette to no selected element and adds a new node to the list of nodes. The new node is created by the newNode function that first finds the highest used node id and created a new Node record with the provided type, id and placed at the provided position.

<details>
<summary>Example</summary>

```elm

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

```

</details>

Finally we update the Main module to use the editor. The init method should be updated by adding an editor and altering the rest of the model to conform with new types. Furthermore, the `view` method should be altered to use the `Editor` module to display the editor .

<details>
<summary>Example</summary>

```elm

module Main exposing (..)
import Html exposing (programWithFlags, h1, text, div)
import Pallette exposing (pallette)
import Types exposing (..)
import Update exposing(update)
import Editor exposing(editor)
main =
    Html.program { view = view, init = init, update = update, subscriptions = subscriptions }

init = ({ 
  pallette = {
    x=10
    , y=10
    , height = 500
    , width = 100
    , elements = [
      {
        id = 1
        , text = "Place"
        , selected = False
        , nodeType = Place 
      }
      ,{
        id = 2
        , text = "Transition"
        , selected = False
        , nodeType = Transition
      }
    ]
  }
  , editor = {
    x=110
    , y=10
    , height = 1000
    , width = 1200
  } 
  , nodes = []
 }, Cmd.none)

subscriptions model = Sub.none

view model = 
  div [][
       pallette model
       ,editor model
   ]
```

</details>

<!-- 
In the init method, we have added a node type to the elements in the pallet. Furthermore, we have added the definition of the editor to the Model record returned by init. The  editor is placed at x=110 and y=10 and is given 1000 pixels in height and 1200 pixels in width. In the view function, we now, in addition to calling the pallette function, call the editor finction and let the result be the second element of the list which is the second argument to the div section. This makes the editor to be rendered as a part of the div created by the div finction in view. -->

### Verification
Repeat the verification steps from step 3. You should now be able to add new nodes to the editor by first selecting a node type on the pallette and then clicking on the editor to place the node on the editor.

## Bonus tasks

An example of how the bonus tasks could be implemented, is available at: <https://gitlab.com/kentis/elm-pn-editor>