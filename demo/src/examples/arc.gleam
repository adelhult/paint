import paint as p

pub fn arc_example() -> p.Picture {
  let radius = 40.0
  p.arc(radius, p.angle_deg(0.0), p.angle_deg(100.0))
}
