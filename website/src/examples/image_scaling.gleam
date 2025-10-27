//// You may want to use the the image_scaling_pixelated function if you
//// are making use of pixel art.

import paint as p
import paint/canvas

pub fn pixel_art() {
  // https://kenney.nl/assets/pixel-platformer
  canvas.image_from_src("./priv/static/pixel_art_example.png")
}

pub fn image_scaling_example() -> p.Picture {
  let size = 24 * 3
  p.combine([
    p.image(pixel_art(), width_px: size, height_px: size)
      |> p.translate_x(-70.0)
      |> p.image_scaling_pixelated,
    p.image(pixel_art(), width_px: size, height_px: size)
      |> p.translate_x(-5.0)
      // default behaviour
      |> p.image_scaling_smooth,
  ])
  |> p.translate_y(-30.0)
}
