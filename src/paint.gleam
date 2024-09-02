import gleam/int
import gleam_community/maths/elementary.{pi}
import impl_canvas

/// A 2D picture
pub opaque type Picture {
  // Shapes
  Blank
  Polygon(List(Vec2), closed: Bool)
  Arc(radius: Float, start: Angle, end: Angle)
  Text(text: String, style: FontProperties)
  // TODO: Bitmap images
  // Styling
  Fill(Picture, Color)
  Stroke(Picture, StrokeProperties)
  // Transform
  Translate(Picture, Vec2)
  Scale(Picture, Vec2)
  Rotate(Picture, Angle)
  // Combine
  Combine(List(Picture))
}

/// Options for strokes. Either no stroke or
/// a stroke with some given color and line width.
pub type StrokeProperties {
  NoStroke
  SolidStroke(Color, Float)
}

/// Internal type used to decouple the font styling
/// from the back-end.
type FontProperties {
  FontProperties(size_px: Int, font_family: String)
}

/// An angle in clock-wise direction.
/// See: `angle_rad` and `angle_deg`.
pub opaque type Angle {
  Radians(Float)
}

/// Create an angle expressed in radians
pub fn angle_rad(radians: Float) -> Angle {
  Radians(radians)
}

/// Create an angle expressed in degrees
pub fn angle_deg(degrees: Float) -> Angle {
  Radians(degrees *. pi() /. 180.0)
}

/// A color. See: `color_rgb`.
pub opaque type Color {
  Rgb(Int, Int, Int)
}

/// Given three Ints [0-255], create a color
pub fn color_rgb(red: Int, green: Int, blue: Int) -> Color {
  Rgb(red, green, blue)
}

/// Convert a hexadecimal string to a color, for example:
/// "#eee", "#efefef" and "abc123"
// pub fn color_hex(hex: String) -> Result(Color, Nil) {
//   todo
// }

pub type Vec2 =
  #(Float, Float)

/// A blank image
pub fn blank() -> Picture {
  Blank
}

/// A circle with some given radius
pub fn circle(radius: Float) -> Picture {
  Arc(radius, start: Radians(0.0), end: Radians(2.0 *. pi()))
}

/// An arc with some radius going from some
/// starting angle to some other angle in clock-wise direction
pub fn arc(radius: Float, start: Angle, end: Angle) -> Picture {
  Arc(radius, start: start, end: end)
}

pub fn polygon(points: List(#(Float, Float))) -> Picture {
  Polygon(points, True)
}

pub fn lines(points: List(#(Float, Float))) -> Picture {
  Polygon(points, False)
}

pub fn rectangle(width: Float, height: Float) -> Picture {
  polygon([#(0.0, 0.0), #(width, 0.0), #(width, height), #(0.0, height)])
}

pub fn square(length: Float) -> Picture {
  rectangle(length, length)
}

pub fn text(text: String, font_size_px: Int) -> Picture {
  Text(text, style: FontProperties(font_size_px, "sans-serif"))
}

pub fn translate(picture: Picture, x: Float, y: Float) -> Picture {
  Translate(picture, #(x, y))
}

pub fn translate_x(picture: Picture, x: Float) -> Picture {
  translate(picture, x, 0.0)
}

pub fn translate_y(picture: Picture, y: Float) -> Picture {
  translate(picture, 0.0, y)
}

/// Scale the picture in the horizontal direction
pub fn scale_x(picture: Picture, factor: Float) -> Picture {
  Scale(picture, #(factor, 1.0))
}

/// Scale the picture in the vertical direction
pub fn scale_y(picture: Picture, factor: Float) -> Picture {
  Scale(picture, #(1.0, factor))
}

/// Scale the picture uniformly in horizontal and vertical direction
pub fn scale(picture: Picture, factor: Float) -> Picture {
  Scale(picture, #(factor, factor))
}

/// Rotate the picture in a clock-wise direction
pub fn rotate(picture: Picture, angle: Angle) -> Picture {
  Rotate(picture, angle)
}

/// Fill a picture with some given color
pub fn fill(picture: Picture, color: Color) -> Picture {
  Fill(picture, color)
}

/// Set properties for the stroke
pub fn stroke(picture: Picture, stroke_properties: StrokeProperties) -> Picture {
  Stroke(picture, stroke_properties)
}

pub fn concat(picture: Picture, another_picture: Picture) -> Picture {
  combine([picture, another_picture])
}

/// Combine multiple pictures into one
pub fn combine(pictures: List(Picture)) -> Picture {
  Combine(pictures)
}

// HTML Canvas Api

fn color_to_css(color: Color) -> String {
  let Rgb(r, g, b) = color
  "rgb("
  <> int.to_string(r)
  <> ", "
  <> int.to_string(g)
  <> ", "
  <> int.to_string(b)
  <> ")"
}

/// Display a picture on a HTML canvas element
pub fn display_on_canvas(picture: Picture, id: String) {
  let ctx = impl_canvas.get_rendering_context(id)
  impl_canvas.reset(ctx)
  display_on_rendering_context(
    picture,
    ctx,
    DrawingState(fill: False, stroke: True),
  )
}

/// Additional state used when drawing
/// (note that the fill and stroke color as well as the stroke width
/// is stored inside of the context)
type DrawingState {
  DrawingState(fill: Bool, stroke: Bool)
}

fn display_on_rendering_context(
  picture: Picture,
  ctx: impl_canvas.RenderingContext2D,
  state: DrawingState,
) {
  case picture {
    Blank -> Nil

    Text(text, properties) -> {
      let FontProperties(size_px, font_family) = properties
      impl_canvas.save(ctx)
      impl_canvas.text(
        ctx,
        text,
        int.to_string(size_px) <> "px " <> font_family,
      )
      impl_canvas.restore(ctx)
    }

    Polygon(points, closed) -> {
      impl_canvas.polygon(ctx, points, closed, state.fill, state.stroke)
    }

    Arc(radius, start, end) -> {
      let Radians(start_radians) = start
      let Radians(end_radians) = end
      impl_canvas.arc(
        ctx,
        radius,
        start_radians,
        end_radians,
        state.fill,
        state.stroke,
      )
    }

    Fill(p, color) -> {
      impl_canvas.save(ctx)
      impl_canvas.set_fill_color(ctx, color_to_css(color))
      display_on_rendering_context(p, ctx, DrawingState(..state, fill: True))
      impl_canvas.restore(ctx)
    }

    Stroke(p, stroke) -> {
      case stroke {
        NoStroke ->
          display_on_rendering_context(
            p,
            ctx,
            DrawingState(..state, stroke: False),
          )
        SolidStroke(color, width) -> {
          impl_canvas.save(ctx)
          impl_canvas.set_stroke_color(ctx, color_to_css(color))
          impl_canvas.set_line_width(ctx, width)
          display_on_rendering_context(
            p,
            ctx,
            DrawingState(..state, stroke: True),
          )
          impl_canvas.restore(ctx)
        }
      }
    }

    Translate(p, vec) -> {
      let #(x, y) = vec
      impl_canvas.translate(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      impl_canvas.reset_transform(ctx)
      // TODO: FIX THIS! calling translate |> rotate etc... will cause issues
    }

    Scale(p, vec) -> {
      let #(x, y) = vec
      impl_canvas.scale(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      impl_canvas.reset_transform(ctx)
      // TODO: FIX THIS! calling translate |> rotate etc... will cause issues
    }

    Rotate(p, angle) -> {
      let Radians(rad) = angle
      impl_canvas.rotate(ctx, rad)
      display_on_rendering_context(p, ctx, state)
      impl_canvas.reset_transform(ctx)
      // TODO: FIX THIS! calling translate |> rotate etc... will cause issues
    }

    Combine(pictures) -> {
      case pictures {
        [] -> Nil
        [p, ..ps] -> {
          display_on_rendering_context(p, ctx, state)
          display_on_rendering_context(Combine(ps), ctx, state)
        }
      }
    }
  }
}
