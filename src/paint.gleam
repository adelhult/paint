//// This module contains the main `Picture` type as well as the
//// function you can use to construct, modify and combine pictures.

import gleam/result
import gleam_community/colour
import paint/internal/types as internal_implementation

/// A 2D picture. This is the type which this entire library revolves around.
///
///> [!NOTE]
///> Unless you intend to author a new backend you should **consider this type opaque and never use any of its constructors**.
///> Instead, make use of the many utility functions defined in this module (`circle`, `combine`, `fill`, etc.)
pub type Picture =
  internal_implementation.Picture

/// A segment from a 2D path.
///
///> [!NOTE]
///> Unless you intend to author a new backend you should **consider this type opaque and never use any of its constructors**.
///> Instead, make use the functions with the `path_` prefix.
pub type PathSegment =
  internal_implementation.PathSegment

/// A reference to an image (i.e. a texture), not to be confused with the `Picture` type.
/// To create an image, see the image functions in the `canvas` back-end.
pub type Image =
  internal_implementation.Image

pub type RotationDirection {
  Clockwise
  Counterclockwise
}

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

/// A blank picture
pub fn blank() -> Picture {
  internal_implementation.Blank
}

/// A circle with some given radius
pub fn circle(radius: Float) -> Picture {
  internal_implementation.Path([
    internal_implementation.ArcCentre(
      centre: #(0.0, 0.0),
      radius:,
      start_angle: internal_implementation.Radians(0.0),
      end_angle: internal_implementation.Radians(2.0 *. pi()),
      counterclockwise: True,
    ),
  ])
}

/// An arc with some radius going from some
/// starting angle to some other angle in clock-wise direction
pub fn arc(
  radius: Float,
  start: Angle,
  end: Angle,
  direction: RotationDirection,
) -> Picture {
  internal_implementation.Path([
    internal_implementation.ArcCentre(
      centre: #(0.0, 0.0),
      radius:,
      start_angle: start,
      end_angle: end,
      counterclockwise: case direction {
        Clockwise -> False
        Counterclockwise -> True
      },
    ),
  ])
}

/// A path
pub fn path(start: Vec2, segments: List(PathSegment)) -> Picture {
  internal_implementation.Path([
    internal_implementation.MoveTo(start),
    ..segments
  ])
}

/// Move to in path
pub fn path_move(to: Vec2) -> PathSegment {
  internal_implementation.MoveTo(to)
}

/// Line to in path
pub fn path_line(to: Vec2) -> PathSegment {
  internal_implementation.LineTo(to)
}

/// Arc in path, defined as centre and start/end angles
pub fn path_arc_centre(
  centre centre: Vec2,
  radius radius: Float,
  start_angle start_angle: Angle,
  end_angle end_angle: Angle,
  direction direction: RotationDirection,
) -> PathSegment {
  internal_implementation.ArcCentre(
    centre:,
    radius:,
    start_angle:,
    end_angle:,
    counterclockwise: case direction {
      Clockwise -> False
      Counterclockwise -> True
    },
  )
}

/// Arc in path, defined as corner point and end point
pub fn path_arc_corner(
  corner corner: Vec2,
  end end: Vec2,
  radius radius: Float,
) -> PathSegment {
  internal_implementation.ArcCorner(corner:, end:, radius:)
}

/// Bezier curve in path
pub fn path_bezier(cp1 cp1: Vec2, cp2 cp2: Vec2, end end: Vec2) -> PathSegment {
  internal_implementation.BezierTo(cp1:, cp2:, end:)
}

/// A rectangle with some given width and height
pub fn rectangle(width: Float, height: Float) -> Picture {
  path(#(0.0, 0.0), [
    path_line(#(width, 0.0)),
    path_line(#(width, height)),
    path_line(#(0.0, height)),
    path_line(#(0.0, 0.0)),
  ])
}

/// A square
pub fn square(length: Float) -> Picture {
  rectangle(length, length)
}

/// Draw an image such as a PNG, JPEG or an SVG. See the `canvas` back-end for more details on how to load images.
pub fn image(image: Image, width_px width_px, height_px height_px) -> Picture {
  // TODO: add a function that allows us to draw only part of an image, flip, and if we want smooth scaling or not
  internal_implementation.ImageRef(image, width_px:, height_px:)
}

/// Set image scaling to be smooth (this is the default behaviour)
pub fn image_scaling_smooth(picture: Picture) -> Picture {
  internal_implementation.ImageScalingBehaviour(
    picture,
    internal_implementation.ScalingSmooth,
  )
}

/// Disable smooth image scaling, suitable for pixel art.
pub fn image_scaling_pixelated(picture: Picture) -> Picture {
  internal_implementation.ImageScalingBehaviour(
    picture,
    internal_implementation.ScalingPixelated,
  )
}

/// Text with some given font size
pub fn text(text: String, px font_size: Int) -> Picture {
  internal_implementation.Text(text, size_px: font_size)
}

/// Horizontal alignment for text. See `text_align`.
pub type TextAlign {
  /// The text is aligned at the normal start of the line (left-aligned for left-to-right locales, right-aligned for right-to-left locales).
  TextAlignStart
  /// The text is aligned at the normal end of the line (right-aligned for left-to-right locales, left-aligned for right-to-left locales).
  TextAlignEnd
  /// The text is left-aligned.
  TextAlignLeft
  /// The text is right-aligned.
  TextAlignRight
  /// The text is centered.
  TextAlignCenter
}

/// Vertical baseline for text. See `text_baseline`.
pub type TextBaseline {
  /// The text baseline is the top of the em square.
  TextBaselineTop
  /// The text baseline is the hanging baseline. (Used by Tibetan and other Indic scripts.)
  TextBaselineHanging
  /// The text baseline is the middle of the em square.
  TextBaselineMiddle
  /// The text baseline is the normal alphabetic baseline. Default value.
  TextBaselineAlphabetic
  /// The text baseline is the ideographic baseline; this is the bottom of the body of the characters,
  /// if the main body of characters protrudes beneath the alphabetic baseline. (Used by Chinese, Japanese, and Korean scripts.)
  TextBaselineIdeographic
  /// The text baseline is the bottom of the bounding box. This differs from the ideographic baseline in that the ideographic baseline doesn't consider descenders.
  TextBaselineBottom
}

/// Writing direction for text. See `text_direction`.
pub type TextDirection {
  /// Left to right
  TextDirectionLtr
  /// Right to left
  TextDirectionRtl
  /// Inherited
  Inherit
}

/// Set the font family used to render `text` inside the picture.
pub fn font_family(picture: Picture, family: String) -> Picture {
  internal_implementation.FontFamily(picture, family)
}

/// Set the horizontal text alignment used to render `text` inside the picture.
pub fn text_align(picture: Picture, alignment: TextAlign) -> Picture {
  internal_implementation.TextAlign(picture, case alignment {
    // Ideally this internal type should be public
    TextAlignStart -> internal_implementation.TextAlignStart
    TextAlignEnd -> internal_implementation.TextAlignEnd
    TextAlignLeft -> internal_implementation.TextAlignLeft
    TextAlignRight -> internal_implementation.TextAlignRight
    TextAlignCenter -> internal_implementation.TextAlignCenter
  })
}

/// Set the vertical text baseline used to render `text` inside the picture.
pub fn text_baseline(picture: Picture, baseline: TextBaseline) -> Picture {
  internal_implementation.TextBaseline(picture, case baseline {
    // Ideally this internal type should be public
    TextBaselineTop -> internal_implementation.TextBaselineTop
    TextBaselineHanging -> internal_implementation.TextBaselineHanging
    TextBaselineMiddle -> internal_implementation.TextBaselineMiddle
    TextBaselineAlphabetic -> internal_implementation.TextBaselineAlphabetic
    TextBaselineIdeographic -> internal_implementation.TextBaselineIdeographic
    TextBaselineBottom -> internal_implementation.TextBaselineBottom
  })
}

/// Set the writing direction used to render `text` inside the picture.
pub fn text_direction(picture: Picture, direction: TextDirection) -> Picture {
  internal_implementation.TextDirection(picture, case direction {
    // Ideally this internal type should be public
    TextDirectionLtr -> internal_implementation.TextDirectionLtr
    TextDirectionRtl -> internal_implementation.TextDirectionRtl
    Inherit -> internal_implementation.TextDirectionInherit
  })
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
  stroke_dashed(picture, colour, width:, dashes: [])
}

/// Set a dashed stroke with some given colour and width
pub fn stroke_dashed(
  picture: Picture,
  colour: Colour,
  width width: Float,
  dashes dashes: List(Float),
) -> Picture {
  internal_implementation.Stroke(
    picture,
    internal_implementation.DashedStroke(colour, width:, dashes:),
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

// Internal utility function to get Pi π
@external(erlang, "math", "pi")
@external(javascript, "./numbers_ffi.mjs", "pi")
fn pi() -> Float {
  3.1415926
}
