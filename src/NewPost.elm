module NewPost exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import LoadingStatus exposing (..)


type alias Model =
    { author : String
    , content : String
    , loadingStatus : LoadingStatus
    , loadingImage : String
    }


type Msg
    = UpdateAuthor String
    | UpdateContent String
    | AttemptCreatePost String String
    | CreatePostSuccess
    | CreatePostFailure


init : String -> ( Model, Cmd Msg )
init path =
    ( { author = ""
      , content = ""
      , loadingStatus = Complete
      , loadingImage = path
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

        AttemptCreatePost author content ->
            ( { model | loadingStatus = Loading }, Cmd.none )

        CreatePostSuccess ->
            ( { model | loadingStatus = Complete, content = "" }, Cmd.none )

        CreatePostFailure ->
            ( { model | loadingStatus = Error }, Cmd.none )


handleSubmit : Model -> Msg
handleSubmit model =
    AttemptCreatePost model.author model.content


view : Model -> Html Msg
view model =
    Html.form [ class "new-post", onSubmit (handleSubmit model) ]
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
        , button [ class "new-post__submit" ] [ renderButtonInternals model.loadingStatus model.loadingImage ]
        ]


renderButtonInternals : LoadingStatus -> String -> Html Msg
renderButtonInternals loadingStatus image =
    case loadingStatus of
        Loading ->
            img [ alt "loading indicator", class "app__loading-icon", src image ] []

        Complete ->
            text "Post"

        Error ->
            text "Error, try again?"
