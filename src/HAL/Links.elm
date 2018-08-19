module HAL.Links exposing (Links, decodeLinks, decodeResourceObject)

{-| This module exposes types and decoders for the colection of links, and HAL Resource Objects

@docs Links
@docs decodeLinks
@docs decodeResourceObject

-}

import Dict exposing (Dict)
import HAL.Link as Link exposing (Link)
import Json.Decode as Decode exposing (Decoder, bool, field, nullable, string)


{-|

    Alias for object of links, a multi-dictionary of individual Link objects

-}
type alias Links =
    Dict String (List Link)


decodeOneOrMany : Decoder a -> Decoder (List a)
decodeOneOrMany dec =
    Decode.oneOf
        [ Decode.list dec
        , Decode.map (\x -> [ x ]) dec
        ]


decodeMultiDict : Decoder a -> Decoder (Dict String (List a))
decodeMultiDict dec =
    Decode.dict (decodeOneOrMany dec)


{-|

    Decode the links object, that is, an object containing for each key, a link object or array of link objects.

    Curies are treated as any other link object and not specifically validated.

-}
decodeLinks : Decoder Links
decodeLinks =
    decodeMultiDict Link.decode


{-|

    Decode an entire Resource object, using a decoder for the resource, as well as a decoder for embedded resources.
    As decodeLinks, curies are not treated differently than other link objects.

-}
decodeResourceObject :
    Decoder resource
    -> Decoder embedded
    -> Decoder ( resource, Links, Dict String (List embedded) )
decodeResourceObject res emb =
    Decode.map3 (\res links embedded -> ( res, links, embedded ))
        res
        (Decode.field "_links" decodeLinks)
        (Decode.field "_embedded" (decodeMultiDict emb))
