module Links exposing (..)

import Dict exposing (Dict)
import Expect exposing (Expectation)
import HAL.Link as Link exposing (empty)
import HAL.Links as Links exposing (Links)
import Json.Decode as Decode exposing (decodeString, dict, value)
import Test exposing (..)


suite : Test
suite =
    describe "The HAL.Links module"
        [ describe "decodeLinks"
            [ rfcCase
            , noLinksCase
            ]
        ]


rfcCase : Test
rfcCase =
    makeCase "RFC Example"
        """
{
     "_links": {
            "self": { "href": "/orders" },
            "next": { "href": "/orders?page=2" },
            "find": { "href": "/orders{?id}", "templated": true }
     },
     "_embedded": {
         "orders": [{
             "_links": {
                 "self": { "href": "/orders/123" },
                 "basket": { "href": "/baskets/98712" },
                 "customer": { "href": "/customers/7809" }
           },
           "total": 30.00,
           "currency": "USD",
           "status": "shipped"
         },{
             "_links": {
                 "self": { "href": "/orders/124" },
                 "basket": { "href": "/baskets/97213" },
                 "customer": { "href": "/customers/12369" }
           },
           "total": 20.00,
           "currency": "USD",
           "status": "processing"
       }]
     },
     "currentlyProcessing": 14,
     "shippedToday": 20
}
        """
        (dict (Decode.map (\_ -> ()) value))
        (Decode.map (\_ -> ()) value)
        ( rfcDict, rfcLinks, rfcEmbedded )


rfcDict : Dict String ()
rfcDict =
    makeDict
        [ ( "currentlyProcessing", () )
        , ( "shippedToday", () )
        , ( "_links", () )
        , ( "_embedded", () )
        ]


rfcLinks : Links
rfcLinks =
    makeDict
        [ ( "self", [ Link.fromHref "/orders" ] )
        , ( "next", [ Link.fromHref "/orders?page=2" ] )
        , ( "find", [ { empty | href = "/orders{?id}", templated = Just True } ] )
        ]


rfcEmbedded : Dict String (List ())
rfcEmbedded =
    Dict.singleton "orders" [ (), () ]


makeDict : List ( comparable, v ) -> Dict comparable v
makeDict =
    List.foldr (\( k, v ) -> Dict.insert k v) Dict.empty


type alias Name =
    String


makeCase :
    Name
    -> String
    -> Decode.Decoder a
    -> Decode.Decoder b
    -> ( a, Links, Dict String (List b) )
    -> Test
makeCase description input res emb result =
    test description
        (\_ ->
            Expect.equal (decodeString (Links.decodeResourceObject res emb) input) (Ok result)
        )


noLinksCase : Test
noLinksCase =
    makeCase "Empty object"
        """
        {
        }
        """
        (Decode.map (\_ -> ()) value)
        (Decode.map (\_ -> ()) value)
        ( (), Dict.empty, Dict.empty )
