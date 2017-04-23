module PostService exposing (..)

import Http
import Task
import Json.Encode as Encode
import Json.Decode exposing (list, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Post exposing (Post)


createUrl : String -> String
createUrl path =
    "http://localhost:8080/api/" ++ path


postDecoder : Decoder Post
postDecoder =
    decode Post
        |> required "author" string
        |> required "content" string
        |> required "displayTime" string


decodePosts : Decoder (List Post)
decodePosts =
    list postDecoder


getPosts : Task.Task Http.Error (List Post)
getPosts =
    Http.toTask (Http.get (createUrl "posts") decodePosts)


createNewPost : String -> String -> Http.Request Post
createNewPost author content =
    Http.post
        (createUrl "posts?delay=2000")
        (Http.jsonBody
            (Encode.object
                [ ( "author", Encode.string author )
                , ( "content", Encode.string content )
                ]
            )
        )
        postDecoder
