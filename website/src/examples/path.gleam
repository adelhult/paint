import gleam_community/maths
import paint as p

pub fn path_example() -> p.Picture {
  let start_angle = p.angle_rad(maths.atan(0.75))
  let end_angle = p.angle_rad(2.0 *. maths.pi() -. maths.atan(0.75))
  p.path([
    p.move_to(#(40.0, 30.0)),
    p.arc_centre(#(0.0, 0.0), 50.0, start_angle, end_angle, False),
    p.line_to(#(0.0, 0.0)),
    p.line_to(#(40.0, 30.0)),
  ])
}
