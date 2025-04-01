import paint as p

pub fn combine_example() -> p.Picture {
  let circle = p.circle(30.0)
  p.combine([
    circle,
    circle |> p.translate_x(30.0),
    circle |> p.translate_x(-30.0),
  ])
}
