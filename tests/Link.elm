module Link exposing (..)

import Expect exposing (Expectation)
import Json.Decode as Decode exposing (decodeString)
import Json.Hal.Link as Link exposing (Link, fromHref)
import Test exposing (..)


suite : Test
suite =
    describe "The Json.Hal.Link module"
        [ describe "Link.decode"
            (List.map
                (\( x, y, z ) -> makeCase x y z)
                testCases
                ++ [ describe "fails on"
                        [ makeFailCase "empty" ""
                        , makeFailCase "a number" "2"
                        , makeFailCase "a string" "\"Hello\""
                        , makeFailCase "an array" "[]"
                        , makeFailCase "an empty object" "{}"
                        , makeFailCase "an bad href" """{ "href": 2 }"""
                        , makeFailCase "a missing href" """{ "templated": true }"""
                        ]
                   ]
            )
        ]


type alias Name =
    String


makeFailCase : Name -> String -> Test
makeFailCase description input =
    test description
        (\_ -> Expect.err (decodeString Link.decode input))


makeCase : Name -> String -> Link -> Test
makeCase description input result =
    test description
        (\_ ->
            Expect.equal (decodeString Link.decode input) (Ok result)
        )


testCases : List ( String, String, Link )
testCases =
    let
        ordersLink = fromHref "/orders/{?id}"
    in
    [ ( "matches a simple path in href"
      , """
        {
            "href": "/x"
        }
        """
      , fromHref "/x"
      )
    , ( "just simple href"
      , """{ "href": "/orders?page=2" }"""
      , fromHref "/orders?page=2"
      )
    , ( "simple template"
      , """ { "href": "/orders{?id}", "templated": true } """
      , { ordersLink | templated = Just True }
      )
    ]
