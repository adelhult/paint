# Paint
**Make drawings, animations, and games with Gleam!**
[![Package Version](https://img.shields.io/hexpm/v/paint)](https://hex.pm/packages/paint)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/paint/)

Paint is a tiny embedded domain specific language (inspired by [Gloss](https://hackage.haskell.org/package/gloss)).
Make pictures out of basic shapes then style, transform and combine them using the provided functions.

```gleam
import paint

fn main() {
  let my_picture = combine([
    paint.circle(50.),
    paint.rectangle(20., 30) |> paint.translate_x(100.),
    paint.text("Hello world", 20) |> paint.translate_y(100.)
  ])

  paint.display_on_canvas(my_picture, "canvas_id")
}
```

**Want to learn more? Read the [docs](https://hexdocs.pm/paint) or browse the [examples](todo).**

> [!NOTE]
> Currently, there is only a HTML canvas backend for displaying the pictures.
> Hopefully, I will have time to add other backends in the future (such as SVG). Feel free to contribute!

## TODOs
TODO: write todos
