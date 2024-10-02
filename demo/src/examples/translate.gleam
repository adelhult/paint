//// There are three functions that are used to move a picture around.
//// translate_xy, translate_x, and translate_y.

import paint as p

pub fn translate_example() -> p.Picture {
  p.circle(30.0)
  |> p.translate_y(25.0)
  |> p.concat(p.circle(30.0))
}
