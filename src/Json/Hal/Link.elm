module Json.Hal.Link exposing (Link, decode, fromHref)

{-| This module exposes the basic type alias for links, along with a decoder for the link structure


# Types

@docs Link
@docs LinkWithoutHref


# Constructing

@docs empty
@docs fromHref


# Decoding

@docs decode

-}

import Json.Decode as Decode exposing (Decoder, bool, field, nullable, string, succeed)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Json.Encode exposing (Value)


{-| The type for a HAL Link Object

Href is the only mandatory field. All other fields are optional. In particular, templated can either
be explicitly true, false, or not present. Likewise deprecation if present represents that the link is
deprecated. This field includes the value so that it can be interpeted, if it is a string or other documentation.

-}
type alias Link =
    { href : String
    , templated : Maybe Bool
    , mediaType : Maybe String
    , deprecation : Maybe Value
    , name : Maybe String
    , profile : Maybe String
    , title : Maybe String
    , hreflang : Maybe String
    }



nonnull : Decoder (Maybe Value)
nonnull =
    Decode.oneOf
        [ Decode.null Nothing
        , Decode.map Just Decode.value
        ]


{-| Given just an href, constructs a Link with that href and all other fields blank
-}
fromHref : String -> Link
fromHref href =
    { href = href
    , templated = Nothing
    , mediaType = Nothing
    , deprecation = Nothing
    , name = Nothing
    , profile = Nothing
    , title = Nothing
    , hreflang = Nothing
    }


{-| Decode a single HAL Link.

    decodeString decode "{ \"href\": \"/x\" }" = Ok { href = "/x", ...}

-}
decode : Decoder Link
decode =
    Decode.succeed Link
        |> required "href" string
        |> optional "templated" (nullable bool) Nothing
        |> optional "type" (nullable string) Nothing
        |> optional "deprecation" nonnull Nothing
        |> optional "name" (nullable string) Nothing
        |> optional "profile" (nullable string) Nothing
        |> optional "title" (nullable string) Nothing
        |> optional "hreflang" (nullable string) Nothing
