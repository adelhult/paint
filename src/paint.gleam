import gleam/int
import gleam/option.{type Option, None, Some}
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

// HTML Canvas API

/// The configuration of the "canvas"
pub type CanvasConfig {
  CanvasConfig(width: Float, height: Float)
}

/// A list of events
pub type Event {
  /// Triggered before drawing. Contains the number of milliseconds elapsed.
  Tick(Float)
  /// Triggered when a key is pressed
  KeyDown(Key)
  /// Triggered when a key is released
  KeyUp(Key)
}

pub type Key {
  LeftArrow
  RightArrow
  UpArrow
  DownArrow
  Space
}

/// Make animations and games and display them on the given HTML canvas.
/// Follows the same architecture as Elm/Lustre.
/// The type variable "state" can be anything
/// you want. If you are only making a stateless animation, use `Nil`.
/// Note: this function may only be called once the page has loaded and the
/// document and window objects are available.
pub fn interact_on_canvas(
  init: fn(CanvasConfig) -> state,
  update: fn(state, Event) -> state,
  view: fn(state) -> Picture,
  id: String,
) {
  let ctx = impl_canvas.get_rendering_context(id)
  let initial_state =
    init(CanvasConfig(impl_canvas.get_width(ctx), impl_canvas.get_height(ctx)))

  impl_canvas.store_state(initial_state, id)

  let create_key_handler = fn(event_name, constructor) {
    impl_canvas.setup_key_handler(event_name, fn(key_code) {
      let key = parse_key_code(key_code)
      case key {
        Some(key) -> {
          let new_state = update(impl_canvas.get_state(id), constructor(key))
          impl_canvas.store_state(new_state, id)
        }
        None -> Nil
      }
    })
  }
  create_key_handler("keydown", KeyDown)
  create_key_handler("keyup", KeyUp)

  // TODO: Support more events and mouse input

  impl_canvas.setup_request_animation_frame(get_tick_func(ctx, view, update, id))
}

fn parse_key_code(key_code: Int) -> Option(Key) {
  case key_code {
    32 -> Some(Space)
    37 -> Some(LeftArrow)
    38 -> Some(UpArrow)
    39 -> Some(RightArrow)
    40 -> Some(DownArrow)
    _ -> None
  }
}

// Gleam does n ot have recursive let bindings, so I need
// to do this workaround...
fn get_tick_func(ctx, view, update, id) {
  fn() {
    let current_state = impl_canvas.get_state(id)

    // Trigger a tick event before drawing
    let new_state = update(current_state, Tick(0.0))
    impl_canvas.store_state(new_state, id)

    // Create the picture
    let picture = view(new_state)

    // Render the picture on the canvas
    impl_canvas.reset(ctx)
    display_on_rendering_context(
      picture,
      ctx,
      DrawingState(fill: False, stroke: True),
    )
    impl_canvas.setup_request_animation_frame(
      // call myself
      get_tick_func(ctx, view, update, id),
    )
  }
}

/// Display a picture on a HTML canvas element
/// Note: this function may only be called once the page has loaded and the
/// document objects is available.
pub fn display_on_canvas(init: fn(CanvasConfig) -> Picture, id: String) {
  let ctx = impl_canvas.get_rendering_context(id)
  impl_canvas.reset(ctx)
  let picture =
    init(CanvasConfig(impl_canvas.get_width(ctx), impl_canvas.get_height(ctx)))
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
      impl_canvas.save(ctx)
      impl_canvas.translate(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      impl_canvas.restore(ctx)
    }

    Scale(p, vec) -> {
      let #(x, y) = vec
      impl_canvas.save(ctx)
      impl_canvas.scale(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      impl_canvas.restore(ctx)
    }

    Rotate(p, angle) -> {
      let Radians(rad) = angle
      impl_canvas.save(ctx)
      impl_canvas.rotate(ctx, rad)
      display_on_rendering_context(p, ctx, state)
      impl_canvas.restore(ctx)
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

/// Utility function that is useful for cases where you
/// are no interested in the canvas configuration. For example,
/// ```
/// display_on_canvas(just(circle(30.0)), "my_canvas")
/// // instead of...
/// display_on_canvas(fn(_config) { circle(30.0) }, "my_canvas")
/// ```
pub fn just(picture: Picture) -> fn(a) -> Picture {
  fn(_config) { picture }
}

/// Utility to set the origin in the center of the canvas
pub fn center(picture: Picture) -> fn(CanvasConfig) -> Picture {
  fn(config) {
    let CanvasConfig(width, height) = config
    picture |> translate(width *. 0.5, height *. 0.5)
  }
}

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
