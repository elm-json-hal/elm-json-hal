module HAL.Links exposing (..)

import Dict exposing (Dict)
import HAL.Link as Link exposing (Link)
import Json.Decode as Decode exposing (Decoder, bool, field, nullable, string)


type alias Links =
    Dict String (List Link)


decodeOneOrMany : Decoder a -> Decoder (List a)
decodeOneOrMany dec =
    Decode.oneOf
        [ Decode.list dec
        , Decode.map (\x -> [ x ]) dec
        ]



{-
   field "_links" (decodeOneOrMany Link.decode)
   field "_embedded" (embedded)
-}


decodeMultiDict : Decoder a -> Decoder (Dict String (List a))
decodeMultiDict dec =
    Decode.dict (decodeOneOrMany dec)


decodeLinks : Decoder Links
decodeLinks =
    decodeMultiDict Link.decode


decodeResourceObject :
    Decoder resource
    -> Decoder embedded
    -> Decoder ( resource, Links, Dict String (List embedded) )
decodeResourceObject res emb =
    Decode.map3 (\res links embedded -> ( res, links, embedded ))
        res
        (Decode.field "_links" decodeLinks)
        (Decode.field "_embedded" (decodeMultiDict emb))
