import gleam/int
import gleam/list
import paint.{
  type Picture, NoStroke, SolidStroke, angle_deg, arc, blank, circle, color_rgb,
  combine, concat, fill, lines, polygon, rectangle, rotate, scale, square,
  stroke, text, translate_y,
}

pub fn blank_example() -> Picture {
  blank()
}

pub fn circle_example() -> Picture {
  circle(40.0)
}

pub fn arc_example() -> Picture {
  let radius = 40.0
  arc(radius, angle_deg(0.0), angle_deg(100.0))
}

pub fn polygon_example() -> Picture {
  polygon([#(-10.0, -20.0), #(50.0, 30.0), #(-20.0, 50.0)])
}

pub fn lines_example() -> Picture {
  lines([#(-10.0, -20.0), #(50.0, 30.0), #(-20.0, 50.0)])
}

pub fn rectangle_example() -> Picture {
  rectangle(50.0, 80.0)
}

pub fn square_example() -> Picture {
  square(80.0)
}

pub fn text_example() -> Picture {
  text("Hi!", 40)
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

pub fn translate_example() -> Picture {
  circle_example() |> translate_y(25.0) |> concat(circle_example())
}

pub fn scale_example() -> Picture {
  circle_example()
  |> scale(0.5)
  |> concat(circle_example())
}

pub fn rotate_example() -> Picture {
  // A bit more of an advanced example, just for fun!
  combine(
    list.repeat(rectangle_example(), times: 6)
    |> list.index_map(fn(picture, i) {
      rotate(picture, angle_deg(360.0 /. 6.0 *. int.to_float(i)))
    }),
  )
}
