//// Note that you may also remove the default stroke
//// using stroke_none.

import paint as p

pub fn stroke_example() -> p.Picture {
  let yellow = p.colour_hex("#F0CA56")

  p.circle(30.0) |> p.stroke(yellow, width: 5.0)
}
