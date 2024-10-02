//// Note that you may also remove the default stroke
//// using stroke_none.

import paint as p

pub fn stroke_example() -> p.Picture {
  let blue = p.colour_hex("#a6f0fc")

  p.circle(30.0) |> p.stroke(blue, width: 5.0)
}
