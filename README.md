# Paint
**Make drawings, animations, and games with Gleam!**

[![Package Version](https://img.shields.io/hexpm/v/paint)](https://hex.pm/packages/paint)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/paint/)

Paint is a tiny embedded domain specific language (inspired by [Gloss](https://hackage.haskell.org/package/gloss)).
Make pictures out of basic shapes then style, transform, and combine them using the provided functions.

```gleam
import paint

fn main() {
  let my_picture = paint.combine([
    paint.circle(50.),
    paint.rectangle(20., 30.) |> paint.translate_x(100.),
    paint.text("Hello world", 20) |> paint.translate_y(100.)
  ])

  paint.display_on_canvas(fn(_config) { my_picture }, "canvas_id")
}
```

**Want to learn more? Read the [docs](https://hexdocs.pm/paint) or browse the [visual examples](https://adelhult.github.io/paint/).**

> [!NOTE]
> Currently, there is only a HTML canvas backend for displaying the pictures.
> Hopefully, I will have time to add other backends in the future (such as SVG). Feel free to contribute!

## TODOs
- [ ] I'm not super happy with the API for the transformations. The functions `scale`, `translate`, and `rotate` all affect the same underlying transformation matrix.
      This means that the order in which these functions are applied greatly matter. Maybe I could normalize the Picture tree before drawing?
      Or introduce an API more similar to [Haskell diagrams](https://hackage.haskell.org/package/diagrams) and [Diagrammer](https://www.youtube.com/watch?v=gT9Xu-ctNqI).
- [ ] Add more utility functions (especially for parsing color formats)
- [ ] Support (bitmap) images
- [ ] Add another backend
