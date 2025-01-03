import paint as p

pub fn fill_example() -> p.Picture {
  let blue = p.colour_hex("#99CAEB")

  p.circle(30.0)
  |> p.fill(blue)
}
