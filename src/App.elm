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


type LoadingStatus
    = Complete
    | Loading
    | Error


type alias Model =
    { newPost : NewPost.Model
    , logo : String
    , loadingWhite : String
    , loadingBlue : String
    , posts : List Post
    , loadingPosts : LoadingStatus
    }


type alias Flags =
    { logoPath : String
    , loadingWhite : String
    , loadingBlue : String
    }


init : Flags -> ( Model, Cmd Msg )
init paths =
    let
        ( newPost, _ ) =
            NewPost.init
    in
        ( Model newPost paths.logoPath paths.loadingWhite paths.loadingBlue [] Loading
        , Task.attempt handleResponse PostService.getPosts
        )



---- UPDATE ----


type Msg
    = UpdateNewPost NewPost.Msg
    | GetPosts
    | SetPosts (List Post)
    | SetPostsError


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
            ( { model | posts = posts, loadingPosts = Complete }, Cmd.none )

        SetPostsError ->
            ( { model | loadingPosts = Error }, Cmd.none )

        GetPosts ->
            ( { model | loadingPosts = Loading }, Task.attempt handleResponse PostService.getPosts )


handleResponse : Result Http.Error (List Post) -> Msg
handleResponse posts =
    case posts of
        Ok posts ->
            SetPosts posts

        Err _ ->
            SetPostsError



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
            [ button [ class "app__load-more-posts", onClick GetPosts ] [ renderLoadButtonInternals model ]
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


renderLoadButtonInternals : Model -> Html Msg
renderLoadButtonInternals model =
    case model.loadingPosts of
        Error ->
            text "There was a problem fetching posts. Try again?"

        Loading ->
            img [ alt "loading image", class "app__loading-icon", src model.loadingBlue ] []

        Complete ->
            text "Loading more posts..."



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
