import paint as p

pub fn font_family_example() {
  p.combine([
    p.text("Hello", px: 30) |> p.font_family("JetBrains Mono, monospace"),
    p.text("World", px: 30)
      |> p.font_family("Lexend, sans-serif")
      |> p.translate_y(30.0),
  ])
  |> p.translate_x(-42.0)
}
