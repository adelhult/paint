import paint.{
  type Picture, NoStroke, SolidStroke, angle_deg, arc, circle, color_rgb, fill,
  stroke, text,
}

pub fn circle_example() -> Picture {
  let radius = 40.0
  circle(radius)
}

pub fn arc_example() -> Picture {
  let radius = 40.0
  arc(radius, start: angle_deg(0.0), end: angle_deg(100.0))
}

pub fn text_example() -> Picture {
  text("Hi!")
}

pub fn fill_example() -> Picture {
  circle_example() |> fill(blue()) |> stroke(NoStroke)
}

pub fn stroke_example() -> Picture {
  circle_example() |> stroke(SolidStroke(blue(), 5.0))
}

fn blue() {
  color_rgb(64, 110, 142)
}
