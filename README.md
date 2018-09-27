# Elm JSON HAL

Elm library for decoding the [Hypertext Application Language](https://en.wikipedia.org/wiki/Hypertext_Application_Language) in JSON.

# Usage

To use the library, you'll want to import the Link object definition, and likely also the Links type alias.

`import HAL.Link exposing (Link)`

`import HAL.Links exposing (Links)`

Most users will be looking for Json.Hal.decodeResourceObject, which will decode an arbitrary object with \_links and \_embedded fields.

A link can be constructed with either `Link.fromHref` or `Link.empty`. Note that the latter will need to aliased
or imported directly to use record update syntax, as it does not support qualified names.

`Link.fromHref "/"`

or

`{ empty | href = "/a", templated = Just True }`
