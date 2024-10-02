import paint as p

pub fn fill_example() -> p.Picture {
  let pink = p.colour_hex("#ffaff3")

  p.circle(30.0)
  |> p.fill(pink)
}
