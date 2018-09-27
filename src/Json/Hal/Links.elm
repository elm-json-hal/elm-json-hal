module Json.Hal.Links exposing (Links, decodeLinks, decodeResourceObject)

{-| This module exposes types and decoders for the colection of links, and HAL Resource Objects

@docs Links
@docs decodeLinks
@docs decodeResourceObject

-}

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, bool, field, nullable, string)
import Json.Hal.Link as Link exposing (Link)


{-| Alias for object of links, a multi-dictionary of individual Link objects
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


{-| Decode the links object, that is, an object containing for each key, a link object or array of link objects.

Curies are treated as any other link object and not specifically validated.

-}
decodeLinks : Decoder Links
decodeLinks =
    decodeMultiDict Link.decode


decodeLinksField : Decoder Links
decodeLinksField =
    optionalField Dict.empty "_links" decodeLinks


optionalField : a -> String -> Decoder a -> Decoder a
optionalField a name dec =
    Decode.map (Maybe.withDefault a) (Decode.maybe (Decode.field name dec))


{-| Decode an entire Resource object, using a decoder for the resource, as well as a decoder for embedded resources.

As decodeLinks, curies are not treated differently than other link objects.

You are required to supply a decoder for the main resource, as well as embedded resources.
Json.Decode.value can be used

-}
decodeResourceObject :
    Decoder resource
    -> Decoder embedded
    -> Decoder ( resource, Links, Dict String (List embedded) )
decodeResourceObject res emb =
    Decode.map3 (\res links embedded -> ( res, links, embedded ))
        res
        decodeLinksField
        (optionalField Dict.empty "_embedded" (decodeMultiDict emb))


{-| As decodeResourceObject, but explicitly not decoding the _embedded field
-}
decodeResourceObjectNoEmbedded :
    Decoder resource
    -> Decoder ( resource, Links )
decodeResourceObjectNoEmbedded res =
    Decode.map2 (\res links -> ( res, links ))
        res
        decodeLinksField
