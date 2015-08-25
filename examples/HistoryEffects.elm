import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Dict
import Signal exposing ((<~))
import String

import StartApp exposing (start)
import Effects exposing (Effects, Never)

import History


type alias Model =
  { data : Dict.Dict String String
  , current : String
  }

init : String -> (Model, Effects Action)
init key =
  ( Model (Dict.fromList [ ("a", "I'm #a"), ("b", "I'm #b") ]) key
  , setHistory key)


type Action
  = Expand String
  | SettedHistory (Maybe String)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Expand a ->
      ( Model model.data a, setHistory a )
    SettedHistory h ->
      ( model, Effects.none )


setHistory : String -> Effects Action
setHistory url =
  History.setPath ("#" ++ url) `Task.andThen` (always (Task.succeed url))
  |> Task.toMaybe
  |> Task.map SettedHistory
  |> Effects.task


view : Signal.Address Action -> Model -> Html
view address model =
  let
    current = (Maybe.withDefault ("missing #" ++ model.current ++ "!") (Dict.get model.current model.data))
  in
    span []
    [ h2 [] [ text current ]
    , div [] [ text "Click on a link or update the url manually" ]
    , div [] [ a [ href "#a" ] [ text "link to #a" ] ]
    , div [] [ a [ href "#b" ] [ text "link to #b" ] ]
    , div [] [ a [ href "#c" ] [ text "link to #c" ] ]
    , button [ onClick address (Expand "a") ] [ text "a" ]
    , button [ onClick address (Expand "b") ] [ text "b" ]
    , button [ onClick address (Expand "c") ] [ text "c" ]
    ]

app =
  StartApp.start
    { init = init "a"
    , update = update
    , view = view
    , inputs = [ Expand <~ (String.dropLeft 1 <~ (Signal.dropRepeats History.hash)) ]
    }


main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
