module HAL exposing (Link, decode)

{-| This module exposes the basic type alias for links, along with a decoder for the link structure

@docs Link
@docs decode

-}

import Json.Decode as Decode exposing (bool, nullable, string)
import Json.Decode.Pipeline exposing (decode, optional, required)


{-| The type for a link object as per the specification at <https://tools.ietf.org/html/draft-kelly-json-hal-08>

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


{-| Decode a single Hypertext link. This will not handle the entire link set,
so it will need to be combined with the decoder combinators.

Example: { "href": "/x" }

-}
decode : Decode.Decoder Link
decode =
    Json.Decode.Pipeline.decode Link
        |> required "href" string
        |> optional "templated" (nullable bool) Nothing
        |> optional "type" (nullable string) Nothing
        |> optional "deprecation" nonnull Nothing
        |> optional "name" (nullable string) Nothing
        |> optional "profile" (nullable string) Nothing
        |> optional "title" (nullable string) Nothing
        |> optional "hreflang" (nullable string) Nothing
