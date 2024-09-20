# Paint
**Make drawings, animations, and games with Gleam!**

[![Package Version](https://img.shields.io/hexpm/v/paint)](https://hex.pm/packages/paint)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/paint/)

Paint is a tiny embedded domain specific language (inspired by [Gloss](https://hackage.haskell.org/package/gloss)).
Make pictures out of basic shapes then style, transform, and combine them using the provided functions.

![Frame 3(2)](https://github.com/user-attachments/assets/a8b83b58-990a-432a-9034-deebc4d210a6)


```gleam
import paint as p
import paint/canvas

fn main() {
  let my_picture = p.combine([
    p.circle(50.0),
    p.circle(30.0) |> p.fill(p.colour_rgb(0, 200, 200)),
    p.rectangle(100.0, 50.0) |> p.rotate(p.angle_deg(30.0)),
    p.text("Hello world", 20) |> p.translate_y(-65.0),
  ])

  canvas.display(fn(_: canvas.Config) { my_picture }, "#canvas_id")
}
```

**Want to learn more? Read the [docs](https://hexdocs.pm/paint) or browse the [visual examples](https://adelhult.github.io/paint/).**

> [!NOTE]
> Currently, there is only a HTML canvas backend for displaying the pictures.
> Hopefully, I will have time to add other backends in the future (such as SVG). Feel free to contribute!

## Logo
Lucy is borrowed from the [Gleam branding page](https://gleam.run/branding/) and the brush is made by [Delapouite (game icons)](https://game-icons.net/1x1/delapouite/paint-brush.html).

## Changelog
The API is considered unstable until a `1.*.*` release is published.
Changes between versions can be found in the file `CHANGELOG.md`.

## TODOs
- [ ] Would be fun to investigate an API more similar to [Haskell diagrams](https://hackage.haskell.org/package/diagrams) and [Diagrammer](https://www.youtube.com/watch?v=gT9Xu-ctNqI).
- [x] Replace the color functions with [gleam-community/colour](https://hexdocs.pm/gleam_community_colour/)
- [ ] Support (bitmap) images
- [x] Split the library into multiple well structured modules (`paint`, `canvas`, `event`, etc.)
- [x] Allowing arbitrary css selectors instead of requiring ids in `interact_...` and `display_...`
- [x] Improve input handling for `canvas.interact` (more keys and mouse input)
- [ ] Add another backend? SVG or maybe Raylib bindings (for either erlang or node).
- [ ] Write a proper tutorial (and a nicer examples page).
- [ ] More shapes, ellipse for example
- [ ] (Maybe) support gradient fill
