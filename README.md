# Elm JSON HAL

Elm library for decoding the [Hypertext Application Language](https://en.wikipedia.org/wiki/Hypertext_Application_Language) in JSON.

# Usage

To use the library, you'll want to import the Link object definition
`import HAL.Link exposing (Link)`

To decode links from JSON, Decoder instances are included:

decodeResourceObject will decode a resource object.
