# paint

[![Package Version](https://img.shields.io/hexpm/v/paint)](https://hex.pm/packages/paint)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/paint/)

Paint is a Gleam library for making images, animations and small interactive experiences.
Paint is heavily inspired by [Gloss] Haskell library and uses the same domain specific languages approach. To draw an image,
first construct something of the `Picture` type.

[!INFO]
Currently, there is only a HTML canvas backend. But the hope is to later support SVGs and maybe even the BEAM.

```sh
gleam add paint@1
```
```gleam
import paint

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/paint>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
