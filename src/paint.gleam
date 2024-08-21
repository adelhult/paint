import canvas
import gleam/int
import gleam_community/maths/elementary.{pi}

/// A 2D picture
pub opaque type Picture {
  Blank
  Rectangle
  // Remove rectangle, add polygon and line instead
  Arc(radius: Float, start: Angle, end: Angle)
  Text(text: String, style: String)
  Fill(Picture, Color)
  Stroke(Picture, StrokeProperty)
  Translate(Picture, Vec2)
  Scale(Picture, Vec2)
  Rotate(Picture, Angle)
  Combine(List(Picture))
}

pub type StrokeProperty {
  NoStroke
  SolidStroke(Color, Float)
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

/// 2D vector, currently only used for the internal API.
/// The public API just uses seperate parameters for x and y. Might change this later.
type Vec2 {
  Vec2(Float, Float)
}

pub fn circle(radius: Float) -> Picture {
  Arc(radius, start: Radians(0.0), end: Radians(2.0 *. pi()))
}

pub fn arc(radius: Float, start start: Angle, end end: Angle) -> Picture {
  Arc(radius, start: start, end: end)
}

pub fn text(text: String) -> Picture {
  Text(text, style: "20px sans-serif")
  // TODO: Expose a way of changing the font style.
  // Preferably without tying it to the html canvas backend.
}

pub fn translate(picture: Picture, x: Float, y: Float) -> Picture {
  Translate(picture, Vec2(x, y))
}

pub fn translate_x(picture: Picture, x: Float) -> Picture {
  translate(picture, x, 0.0)
}

pub fn translate_y(picture: Picture, y: Float) -> Picture {
  translate(picture, 0.0, y)
}

/// Scale the picture in the horizontal direction
pub fn scale_x(picture: Picture, factor: Float) -> Picture {
  Scale(picture, Vec2(factor, 1.0))
}

/// Scale the picture in the vertical direction
pub fn scale_y(picture: Picture, factor: Float) -> Picture {
  Scale(picture, Vec2(1.0, factor))
}

/// Scale the picture uniformly in horizontal and vertical direction
pub fn scale(picture: Picture, factor: Float) -> Picture {
  Scale(picture, Vec2(factor, factor))
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
pub fn stroke(picture: Picture, stroke_property: StrokeProperty) -> Picture {
  Stroke(picture, stroke_property)
}

pub fn concat(picture: Picture, another_picture: Picture) -> Picture {
  combine([picture, another_picture])
}

/// Combine multiple pictures into one
pub fn combine(pictures: List(Picture)) -> Picture {
  Combine(pictures)
}

// HTML Canvas API

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
  let ctx = canvas.get_rendering_context(id)
  canvas.reset(ctx)
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
  ctx: canvas.RenderingContext2D,
  state: DrawingState,
) {
  case picture {
    Blank -> Nil

    Rectangle -> canvas.fill_rect(ctx)

    Text(text, style) -> {
      canvas.save(ctx)
      canvas.text(ctx, text, style)
      canvas.restore(ctx)
    }

    Arc(radius, start, end) -> {
      let Radians(start_radians) = start
      let Radians(end_radians) = end
      canvas.arc(
        ctx,
        radius,
        start_radians,
        end_radians,
        state.fill,
        state.stroke,
      )
    }

    Fill(p, color) -> {
      canvas.save(ctx)
      canvas.set_fill_color(ctx, color_to_css(color))
      display_on_rendering_context(p, ctx, DrawingState(..state, fill: True))
      canvas.restore(ctx)
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
          canvas.save(ctx)
          canvas.set_stroke_color(ctx, color_to_css(color))
          canvas.set_line_width(ctx, width)
          display_on_rendering_context(
            p,
            ctx,
            DrawingState(..state, stroke: True),
          )
          canvas.restore(ctx)
        }
      }
    }

    Translate(p, vec) -> {
      let Vec2(x, y) = vec
      canvas.translate(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      canvas.reset_transform(ctx)
    }

    Scale(p, vec) -> {
      let Vec2(x, y) = vec
      canvas.scale(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      canvas.reset_transform(ctx)
    }

    Rotate(p, angle) -> {
      let Radians(rad) = angle
      canvas.rotate(ctx, rad)
      display_on_rendering_context(p, ctx, state)
      canvas.reset_transform(ctx)
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
