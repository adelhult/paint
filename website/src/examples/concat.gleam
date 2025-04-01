import paint as p

pub fn concat_example() -> p.Picture {
  let circle = p.circle(30.0)
  circle
  |> p.concat(circle |> p.translate_x(30.0))
}
