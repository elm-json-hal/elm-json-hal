module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import HAL exposing (Link, emptyLink)
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "The HAL.Link module"
        [ describe "Link.decode"
            (List.map
                (\( x, y, z ) -> makeCase x y z)
                testCases
            )
        ]


makeCase : String -> String -> Link -> Test
makeCase description input result =
    test description
        (\_ ->
            Expect.equal (Decode.decodeString HAL.decodeLink input) (Ok result)
        )


testCases : List ( String, String, Link )
testCases =
    [ ( "matches a simple path in href", """
        {
            "href": "/x"
        }
        """, { emptyLink | href = "/x" } )
    , ( "just simple href"
      , """{ "href": "/orders?page=2" }"""
      , { emptyLink | href = "/orders?page=2" }
      )
    , ( "simple template"
      , """ { "href": "/orders{?id}", "templated": true } """
      , { emptyLink | href = "/orders{?id}", templated = Just True }
      )
    ]
