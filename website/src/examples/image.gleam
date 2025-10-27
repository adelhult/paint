import gleam/int
import paint as p
import paint/canvas

// Make sure to also wait for the image to load before
// trying to draw a picture referencing it. Like this:
// ```
// use <- canvas.wait_until_loaded([my_logo_image()])
// ```
pub fn my_logo_image() {
  canvas.image_from_src("./priv/static/logo.svg")
}

pub fn image_example() -> p.Picture {
  let width_px = 133
  let height_px = 123
  p.image(my_logo_image(), width_px:, height_px:)
  |> p.translate_xy(
    int.to_float(-width_px) /. 2.0,
    int.to_float(-height_px) /. 2.0,
  )
}
