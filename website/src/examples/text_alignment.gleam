import paint as p

pub fn alignment_example() {
  let px = 20
  p.combine([
    p.path(#(0.0, -100.0), [p.path_line(#(0.0, 100.0))]),
    p.text("Hello", px:)
      |> p.text_align(p.TextAlignLeft)
      |> p.translate_y(-25.0),
    p.text("Hello", px:)
      |> p.text_align(p.TextAlignRight),
    p.text("Hello", px:)
      |> p.text_align(p.TextAlignCenter)
      |> p.translate_y(25.0),
  ])
}
