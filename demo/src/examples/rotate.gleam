//// You can use the functions angle_deg and angle_rad to make angles.

import paint as p

pub fn rotate_example() -> p.Picture {
  p.square(40.0)
  |> p.rotate(p.angle_deg(45.0))
  |> p.concat(p.square(40.0))
}
