module Link exposing (..)

import Expect exposing (Expectation)
import HAL.Link as Link exposing (Link, empty, fromHref)
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
            Expect.equal (Decode.decodeString Link.decode input) (Ok result)
        )


testCases : List ( String, String, Link )
testCases =
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
      , { empty | href = "/orders{?id}", templated = Just True }
      )
    ]
