import paint as p

pub fn direction_example() {
  let px = 20
  p.combine([
    p.text("Hey!", px:)
      |> p.text_direction(p.TextDirectionLtr)
      |> p.translate_y(25.0),
    p.text("Hey!", px:) |> p.text_direction(p.TextDirectionRtl),
  ])
}
