module NewPost exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)


type alias Model =
    { author : String
    , content : String
    }


type Msg
    = UpdateAuthor String
    | UpdateContent String


init : ( Model, Cmd Msg )
init =
    ( { author = ""
      , content = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateAuthor author ->
            ( { model | author = author }, Cmd.none )

        UpdateContent content ->
            ( { model | content = content }, Cmd.none )


handleSubmit =
    UpdateContent ""


view : Model -> Html Msg
view model =
    Html.form [ class "new-post", onSubmit handleSubmit ]
        [ input
            [ class "new-post__name"
            , onInput UpdateAuthor
            , placeholder "My name is..."
            , required True
            , type_ "text"
            ]
            []
        , textarea
            [ class "new-post__post"
            , cols 30
            , onInput UpdateContent
            , required True
            , placeholder "Let's talk about dev stuff"
            , rows 3
            , value model.content
            ]
            []
        , button [ class "new-post__submit" ] [ text "Post" ]
        ]
