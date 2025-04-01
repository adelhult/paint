//// A visualisation of the code found in the README.md file,
//// just to make sure that the examples are kept up to date with any
//// changes to the API.

import paint as p

pub fn readme_example() -> p.Picture {
  p.combine([
    p.circle(30.0),
    p.circle(20.0) |> p.fill(p.colour_rgb(0, 200, 200)),
    p.rectangle(50.0, 30.0) |> p.rotate(p.angle_deg(30.0)),
    p.text("Hello world", 10) |> p.translate_y(-35.0),
  ])
}
