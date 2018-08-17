module HAL exposing (Link, decodeLink, decodeLinks, emptyLink)

{-| This module exposes the basic type alias for links, along with a decoder for the link structure

@docs Link
@docs decodeLink
@docs decodeLinks
@docs emptyLink

-}

import Json.Decode as Decode exposing (bool, field, nullable, string)
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


{-| A default link, whose href points to "/" and with all optional fields undefined
-}
emptyLink : Link
emptyLink =
    { href = "/"
    , templated = Nothing
    , mediaType = Nothing
    , deprecation = Nothing
    , name = Nothing
    , profile = Nothing
    , title = Nothing
    , hreflang = Nothing
    }


{-| Decode a single Hypertext link. This will not handle the entire link set,
so it will need to be combined with the decoder combinators.

Example: { "href": "/x" }

-}
decodeLink : Decode.Decoder Link
decodeLink =
    decode Link
        |> required "href" string
        |> optional "templated" (nullable bool) Nothing
        |> optional "type" (nullable string) Nothing
        |> optional "deprecation" nonnull Nothing
        |> optional "name" (nullable string) Nothing
        |> optional "profile" (nullable string) Nothing
        |> optional "title" (nullable string) Nothing
        |> optional "hreflang" (nullable string) Nothing


{-| Decode either a single link or multiple links, so if x is a valid link,
then this will match both x and [ x ]
-}
decodeLinks : Decode.Decoder (List Link)
decodeLinks =
    Decode.oneOf
        [ Decode.list decodeLink
        , Decode.map (\x -> [ x ]) decodeLink
        ]


decodeLinksFromObj : Decode.Decoder a -> Decode.Decoder { links : List Link, value : a }
decodeLinksFromObj decoder =
    Decode.map2 (\links val -> { links = links, value = val })
        (field "_links" decodeLinks)
        decoder
