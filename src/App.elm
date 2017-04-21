module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Task
import NewPost
import PostService
import Post exposing (Post)


---- MODEL ----


type alias Model =
    { newPost : NewPost.Model
    , logo : String
    , posts : List Post
    }


init : String -> ( Model, Cmd Msg )
init path =
    let
        ( newPost, _ ) =
            NewPost.init
    in
        ( Model newPost path [], Task.attempt handleResponse PostService.getPosts )



---- UPDATE ----


type Msg
    = UpdateNewPost NewPost.Msg
    | GetPosts
    | SetPosts (List Post)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateNewPost newPostMsg ->
            let
                ( updatedNewPost, _ ) =
                    NewPost.update newPostMsg model.newPost
            in
                ( { model | newPost = updatedNewPost }, Cmd.none )

        SetPosts posts ->
            ( { model | posts = posts }, Cmd.none )

        GetPosts ->
            ( model, Task.attempt handleResponse PostService.getPosts )


handleResponse : Result Http.Error (List Post) -> Msg
handleResponse posts =
    case posts of
        Ok posts ->
            SetPosts posts

        Err err ->
            SetPosts []



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ header [ class "app__top-bar" ]
            [ div [ class "app__top-bar-content" ]
                [ text "Elm"
                , div [ class "app__logo-wrapper" ]
                    [ img [ alt "devmountain logo", class "app__logo", src model.logo ] [] ]
                , text "Chat"
                ]
            ]
        , Html.map UpdateNewPost (NewPost.view model.newPost)
        , div [ class "app__post-wrapper" ]
            [ button [ class "app__load-more-posts", onClick GetPosts ] [ text "Load more posts..." ]
            , div [] (List.map renderPosts model.posts)
            ]
        ]


renderPosts : Post -> Html Msg
renderPosts post =
    div [ class "post" ]
        [ h3 [ class "post__name" ] [ text post.author ]
        , span [ class "post__time" ] [ text post.displayTime ]
        , p [ class "post__content" ] [ text post.content ]
        ]



---- PROGRAM ----


main : Program String Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
