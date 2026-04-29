import paint as p

pub fn stroke_dashed_example() -> p.Picture {
  let yellow = p.colour_hex("#F0CA56")

  p.circle(30.0) |> p.stroke_dashed(yellow, width: 5.0, dashes: [5.0, 5.0])
}
