//// This module contains the main `Picture` type as well as the
//// function you can use to construct, modify and combine pictures.

import gleam/result
import gleam_community/colour
import gleam_community/maths/elementary.{pi}
import paint/internal/types as internal_implementation

/// A 2D picture. This is the type which this entire library revolves around.
///
///> [!NOTE]
///> Unless you intend to author a new backend you should **consider this type opaque and never use any of its constructors**.
///> Instead, make use of the many utility functions defined in this module (`circle`, `combine`, `fill`, etc.)
pub type Picture =
  internal_implementation.Picture

/// An angle in clock-wise direction.
/// See: `angle_rad` and `angle_deg`.
pub type Angle =
  internal_implementation.Angle

/// Create an angle expressed in radians
pub fn angle_rad(radians: Float) -> Angle {
  internal_implementation.Radians(radians)
}

/// Create an angle expressed in degrees
pub fn angle_deg(degrees: Float) -> Angle {
  internal_implementation.Radians(degrees *. pi() /. 180.0)
}

/// A rexport of the Colour type from [gleam_community/colour](https://hexdocs.pm/gleam_community_colour/).
/// Paint also includes the functions `colour_hex` and `colour_rgb` to
/// easily construct Colours, but feel free to import the `gleam_community/colour` module
/// and use the many utility that are provided from there.
pub type Colour =
  colour.Colour

/// A utility around [colour.from_rgb_hex_string](https://hexdocs.pm/gleam_community_colour/gleam_community/colour.html#from_rgb_hex_string)
/// (from `gleam_community/colour`) that **panics** on an invalid hex code.
pub fn colour_hex(string: String) -> Colour {
  result.lazy_unwrap(colour.from_rgb_hex_string(string), fn() {
    panic as "Failed to parse hex code"
  })
}

/// A utility around [colour.from_rgb255](https://hexdocs.pm/gleam_community_colour/gleam_community/colour.html#from_rgb255)
/// (from `gleam_community/colour`) that **panics** if the values are outside of the allowed range.
pub fn colour_rgb(red: Int, green: Int, blue: Int) -> Colour {
  result.lazy_unwrap(colour.from_rgb255(red, green, blue), fn() {
    panic as "The value was not inside of the valid range [0-255]"
  })
}

pub type Vec2 =
  #(Float, Float)

/// A blank image
pub fn blank() -> Picture {
  internal_implementation.Blank
}

/// A circle with some given radius
pub fn circle(radius: Float) -> Picture {
  internal_implementation.Arc(
    radius,
    start: internal_implementation.Radians(0.0),
    end: internal_implementation.Radians(2.0 *. pi()),
  )
}

/// An arc with some radius going from some
/// starting angle to some other angle in clock-wise direction
pub fn arc(radius: Float, start: Angle, end: Angle) -> Picture {
  internal_implementation.Arc(radius, start: start, end: end)
}

/// A polygon consisting of a list of 2d points
pub fn polygon(points: List(#(Float, Float))) -> Picture {
  internal_implementation.Polygon(points, True)
}

/// Lines (same as a polygon but not a closed shape)
pub fn lines(points: List(#(Float, Float))) -> Picture {
  internal_implementation.Polygon(points, False)
}

/// A rectangle with some given width and height
pub fn rectangle(width: Float, height: Float) -> Picture {
  polygon([#(0.0, 0.0), #(width, 0.0), #(width, height), #(0.0, height)])
}

/// A square
pub fn square(length: Float) -> Picture {
  rectangle(length, length)
}

/// Text with some given font size
pub fn text(text: String, px font_size: Int) -> Picture {
  internal_implementation.Text(
    text,
    style: internal_implementation.FontProperties(font_size, "sans-serif"),
  )
  // TODO: expose more styling options (font and text alignment)
}

/// Translate a picture in horizontal and vertical direction
pub fn translate_xy(picture: Picture, x: Float, y: Float) -> Picture {
  internal_implementation.Translate(picture, #(x, y))
}

/// Translate a picture in the horizontal direction
pub fn translate_x(picture: Picture, x: Float) -> Picture {
  translate_xy(picture, x, 0.0)
}

/// Translate a picture in the vertical direction
pub fn translate_y(picture: Picture, y: Float) -> Picture {
  translate_xy(picture, 0.0, y)
}

/// Scale the picture in the horizontal direction
pub fn scale_x(picture: Picture, factor: Float) -> Picture {
  internal_implementation.Scale(picture, #(factor, 1.0))
}

/// Scale the picture in the vertical direction
pub fn scale_y(picture: Picture, factor: Float) -> Picture {
  internal_implementation.Scale(picture, #(1.0, factor))
}

/// Scale the picture uniformly in horizontal and vertical direction
pub fn scale_uniform(picture: Picture, factor: Float) -> Picture {
  internal_implementation.Scale(picture, #(factor, factor))
}

/// Rotate the picture in a clock-wise direction
pub fn rotate(picture: Picture, angle: Angle) -> Picture {
  internal_implementation.Rotate(picture, angle)
}

/// Fill a picture with some given colour, see `Colour`.
pub fn fill(picture: Picture, colour: Colour) -> Picture {
  internal_implementation.Fill(picture, colour)
}

/// Set a solid stroke with some given colour and width
pub fn stroke(picture: Picture, colour: Colour, width width: Float) -> Picture {
  internal_implementation.Stroke(
    picture,
    internal_implementation.SolidStroke(colour, width),
  )
}

/// Remove the stroke of the given picture
pub fn stroke_none(picture: Picture) -> Picture {
  internal_implementation.Stroke(picture, internal_implementation.NoStroke)
}

/// Concatenate two pictures
pub fn concat(picture: Picture, another_picture: Picture) -> Picture {
  combine([picture, another_picture])
}

/// Combine multiple pictures into one
pub fn combine(pictures: List(Picture)) -> Picture {
  internal_implementation.Combine(pictures)
}

/// Utility function that is useful for cases where you
/// are no interested in the canvas configuration. For example,
/// ```
/// canvas.display(just(circle(30.0)), "#my_canvas")
/// // instead of...
/// canvas.display(fn(_config) { circle(30.0) }, "#my_canvas")
/// ```
pub fn just(picture: Picture) -> fn(a) -> Picture {
  fn(_config) { picture }
}
