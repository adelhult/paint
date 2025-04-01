//// There are three functions that are used to scale a picture.
//// scale_uniform, scale_x, and scale_y.

import paint as p

pub fn scale_example() -> p.Picture {
  p.circle(30.0)
  |> p.scale_uniform(0.5)
  |> p.concat(p.circle(30.0))
}
