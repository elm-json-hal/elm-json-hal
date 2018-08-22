module HAL.Link exposing (Link, LinkWithoutHref, decode, empty, fromHref)

{-| This module exposes the basic type alias for links, along with a decoder for the link structure

@docs Link
@docs LinkWithoutHref
@docs decode
@docs empty
@docs fromHref

-}

import Json.Decode as Decode exposing (Decoder, bool, field, nullable, string)
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


{-| A Link missing its mandatory href field.
The field must be updated with a String value in order to construct a Link.
-}
type alias LinkWithoutHref =
    { href : Undefined
    , templated : Maybe Bool
    , mediaType : Maybe String
    , deprecation : Maybe ()
    , name : Maybe String
    , profile : Maybe String
    , title : Maybe String
    , hreflang : Maybe String
    }


type Undefined
    = Undefined


nonnull : Decoder (Maybe ())
nonnull =
    Decode.oneOf
        [ Decode.null Nothing
        , Decode.map (\x -> Just ()) Decode.value
        ]


{-|

    Given just an href, constructs a Link with that href and all other fields blank

-}
fromHref : String -> Link
fromHref href =
    { empty | href = href }


{-|

    Creates a Link with a yet-undefined href, so that it should be filled in via record updates.
    In particular, to be consumed as a link, one should set href to be a String

-}
empty : LinkWithoutHref
empty =
    { href = Undefined
    , templated = Nothing
    , mediaType = Nothing
    , deprecation = Nothing
    , name = Nothing
    , profile = Nothing
    , title = Nothing
    , hreflang = Nothing
    }


{-| Decode a single HAL Link.

    `decodeString decode "{ \"href\": \"/x\" }" = Ok { href = "/x", ...}`

-}
decode : Decoder Link
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
