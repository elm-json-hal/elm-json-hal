module HAL exposing (..)

{-|

    This module exposes the basic type aliases for links

@docs HypertextLink
@docs decode

-}

import Json.Decode as Decode


{-| The type for a link object as per the specification at <https://tools.ietf.org/html/draft-kelly-json-hal-08>
-}
type alias HypertextLink =
    { href : String
    , templated : Maybe Bool
    , mediaType : Maybe String
    , deprecation : Maybe ()
    , name : Maybe String
    , profile : Maybe String
    , title : Maybe String
    , hreflang : Maybe String
    }


{-| Decode a single Hypertext link. This will not handle the entire link set,
so it will need to be combined with the decoder combinators.

Example: { "href": "/x" }

-}
decode : Decode.Decoder HypertextLink
decode =
    Decode.fail "fail"
