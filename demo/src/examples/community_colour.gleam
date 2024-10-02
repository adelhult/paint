//// paint uses gleam_community_colour which means that you are free
//// to import and use any of the many functions and predefined colours from that package.
//// However, paint also provides the functions colour_hex and colour_rgb for convenience.

import gleam/int
import gleam/list
import gleam_community/colour
import paint as p

pub fn community_colour_example() -> p.Picture {
  let assert Ok(semi_transparent) = colour.from_rgba(0.3, 0.3, 0.0, 0.5)
  let colours = [colour.dark_red, colour.blue, semi_transparent]

  p.combine(
    list.index_map(colours, fn(c, i) {
      p.circle(30.0) |> p.fill(c) |> p.translate_x(int.to_float(i) *. 30.0)
    }),
  )
  // center
  |> p.translate_x(-30.0)
}
