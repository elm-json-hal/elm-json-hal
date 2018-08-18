module HAL.Link exposing (Link, decode, empty)

{-| This module exposes the basic type alias for links, along with a decoder for the link structure

@docs Link
@docs decode
@docs empty

-}

import Json.Decode as Decode exposing (bool, field, nullable, string)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


{-| The type for a HAL Link Object as per the specification at <https://tools.ietf.org/html/draft-kelly-json-hal-08>

A field typed with Maybe here is always an optional field

-}
type alias Link =
    { href : String
    , templated : Maybe Bool
    , mediaType : Maybe String
    , deprecation : Maybe ()
    , name : Maybe String
    , profile : Maybe String
    , title : Maybe String
    , hreflang : Maybe String
    }


nonnull : Decode.Decoder (Maybe ())
nonnull =
    Decode.oneOf
        [ Decode.null Nothing
        , Decode.map (\x -> Just ()) Decode.value
        ]


{-| A link with all optional fields left undefined, and the href field set to "/"
-}
empty : Link
empty =
    { href = "/"
    , templated = Nothing
    , mediaType = Nothing
    , deprecation = Nothing
    , name = Nothing
    , profile = Nothing
    , title = Nothing
    , hreflang = Nothing
    }


{-| Decode a single HAL Link.

Example: The object { "href": "/x" } will be decoded to the link { empty | href = "/x" }

-}
decode : Decode.Decoder Link
decode =
    Pipeline.decode Link
        |> required "href" string
        |> optional "templated" (nullable bool) Nothing
        |> optional "type" (nullable string) Nothing
        |> optional "deprecation" nonnull Nothing
        |> optional "name" (nullable string) Nothing
        |> optional "profile" (nullable string) Nothing
        |> optional "title" (nullable string) Nothing
        |> optional "hreflang" (nullable string) Nothing


decodeLinks : Decode.Decoder (List Link)
decodeLinks =
    Decode.oneOf
        [ Decode.list decode
        , Decode.map (\x -> [ x ]) decode
        ]
