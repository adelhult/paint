import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam_community/colour
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
  Fill(Picture, Colour)
  Stroke(Picture, StrokeProperties)
  // Transform
  Translate(Picture, Vec2)
  Scale(Picture, Vec2)
  Rotate(Picture, Angle)
  // Combine
  Combine(List(Picture))
}

/// Options for strokes. Either no stroke or
/// a stroke with some given colour and line width.
pub type StrokeProperties {
  NoStroke
  SolidStroke(Colour, Float)
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

/// A polygon consisting of a list of 2d points
pub fn polygon(points: List(#(Float, Float))) -> Picture {
  Polygon(points, True)
}

/// Lines (same as a polygon but not a closed shape)
pub fn lines(points: List(#(Float, Float))) -> Picture {
  Polygon(points, False)
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
pub fn text(text: String, font_size_px: Int) -> Picture {
  Text(text, style: FontProperties(font_size_px, "sans-serif"))
  // TODO: expose more styling options (font and text alignment)
}

/// Translate a picture in horizontal and vertical direction
pub fn translate_xy(picture: Picture, x: Float, y: Float) -> Picture {
  Translate(picture, #(x, y))
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
  Scale(picture, #(factor, 1.0))
}

/// Scale the picture in the vertical direction
pub fn scale_y(picture: Picture, factor: Float) -> Picture {
  Scale(picture, #(1.0, factor))
}

/// Scale the picture uniformly in horizontal and vertical direction
pub fn scale_uniform(picture: Picture, factor: Float) -> Picture {
  Scale(picture, #(factor, factor))
}

/// Rotate the picture in a clock-wise direction
pub fn rotate(picture: Picture, angle: Angle) -> Picture {
  Rotate(picture, angle)
}

/// Fill a picture with some given colour, see `Colour`.
pub fn fill(picture: Picture, colour: Colour) -> Picture {
  Fill(picture, colour)
}

/// Set properties for the stroke. See `StrokeProperties`
pub fn stroke(picture: Picture, stroke_properties: StrokeProperties) -> Picture {
  Stroke(picture, stroke_properties)
}

/// Concatenate two pictures
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
  EventTick(Float)
  /// Triggered when a key is pressed
  EventKeyDown(Key)
  /// Triggered when a key is released
  EventKeyUp(Key)
  /// Triggered when the mouse is moved. Contains
  /// the `x` and `y` value for the mouse position.
  EventMouseMovement(Float, Float)
  /// Triggered when a mouse button is pressed
  EventMouseButtonPressed(MouseButton)
  /// Triggered when a mouse button is released.
  ///
  /// Note, on the web you might encounter issues where the
  /// release event for the right mouse button is not triggered
  /// because of the context menu.
  EventMouseButtonReleased(MouseButton)
}

pub type MouseButton {
  MouseButtonLeft
  MouseButtonRight
  /// The scroll wheel button
  MouseButtonMiddle
}

pub type Key {
  KeyLeftArrow
  KeyRightArrow
  KeyUpArrow
  KeyDownArrow
  KeySpace
  KeyW
  KeyA
  KeyS
  KeyD
  KeyZ
  KeyX
  KeyC
  KeyEnter
  KeyEscape
  KeyBackspace
}

/// Make animations and games and display them on the given HTML canvas
/// (specified by some [CSS Selector](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_selectors)).
///
/// Follows the same architecture as Elm/Lustre.
/// The type variable "state" can be anything
/// you want. If you are only making a stateless animation, use `Nil`.
/// Note: this function may only be called once the page has loaded and the
/// document and window objects are available.
pub fn interact_on_canvas(
  init: fn(CanvasConfig) -> state,
  update: fn(state, Event) -> state,
  view: fn(state) -> Picture,
  selector: String,
) {
  let ctx = impl_canvas.get_rendering_context(selector)
  let initial_state =
    init(CanvasConfig(impl_canvas.get_width(ctx), impl_canvas.get_height(ctx)))

  impl_canvas.set_global(initial_state, selector)

  // Handle keyboard input
  let create_key_handler = fn(event_name, constructor) {
    impl_canvas.setup_input_handler(
      event_name,
      fn(event: impl_canvas.KeyboardEvent) {
        let key = parse_key_code(impl_canvas.get_key_code(event))
        case key {
          Some(key) -> {
            let new_state =
              update(impl_canvas.get_global(selector), constructor(key))
            impl_canvas.set_global(new_state, selector)
          }
          None -> Nil
        }
      },
    )
  }
  create_key_handler("keydown", EventKeyDown)
  create_key_handler("keyup", EventKeyUp)

  // Handle mouse movement
  impl_canvas.setup_input_handler(
    "mousemove",
    fn(event: impl_canvas.MouseEvent) {
      let #(x, y) = impl_canvas.mouse_pos(ctx, event)
      let new_state =
        update(impl_canvas.get_global(selector), EventMouseMovement(x, y))
      impl_canvas.set_global(new_state, selector)
      Nil
    },
  )

  // Handle mouse buttons
  let create_mouse_button_handler = fn(event_name, constructor, check_pressed) {
    impl_canvas.setup_input_handler(
      event_name,
      fn(event: impl_canvas.MouseEvent) {
        // Read the previous state of the mouse
        let previous_event_id = "PAINT_PREVIOUS_MOUSE_INPUT_FOR_" <> selector
        let previous_event = impl_canvas.get_global(previous_event_id)
        // Save this state
        impl_canvas.set_global(event, previous_event_id)

        // A utility to check which buttons was just pressed/released
        let check_button = fn(i) {
          impl_canvas.check_mouse_button(
            event,
            previous_event,
            i,
            check_pressed,
          )
        }

        let trigger_update = fn(button) {
          let new_state =
            update(impl_canvas.get_global(selector), constructor(button))
          impl_canvas.set_global(new_state, selector)
        }

        // Note: it is rather rare, but it seems that multiple buttons
        // can be pressed in the very same MouseEvent, so we may need to
        // trigger multiple events at once.
        case check_button(0) {
          True -> trigger_update(MouseButtonLeft)
          False -> Nil
        }
        case check_button(1) {
          True -> trigger_update(MouseButtonRight)
          False -> Nil
        }
        case check_button(2) {
          True -> trigger_update(MouseButtonMiddle)
          False -> Nil
        }

        Nil
      },
    )
  }
  create_mouse_button_handler("mousedown", EventMouseButtonPressed, True)
  create_mouse_button_handler("mouseup", EventMouseButtonReleased, False)

  impl_canvas.setup_request_animation_frame(get_tick_func(
    ctx,
    view,
    update,
    selector,
  ))
}

fn parse_key_code(key_code: Int) -> Option(Key) {
  case key_code {
    32 -> Some(KeySpace)
    37 -> Some(KeyLeftArrow)
    38 -> Some(KeyUpArrow)
    39 -> Some(KeyRightArrow)
    40 -> Some(KeyDownArrow)
    87 -> Some(KeyW)
    65 -> Some(KeyA)
    83 -> Some(KeyS)
    68 -> Some(KeyD)
    90 -> Some(KeyZ)
    88 -> Some(KeyX)
    67 -> Some(KeyC)
    18 -> Some(KeyEnter)
    27 -> Some(KeyEscape)
    8 -> Some(KeyBackspace)
    _ -> None
  }
}

// Gleam does not have recursive let bindings, so I need
// to do this workaround...
fn get_tick_func(ctx, view, update, selector) {
  fn(time) {
    let current_state = impl_canvas.get_global(selector)

    // Trigger a tick event before drawing
    let new_state = update(current_state, EventTick(time))
    impl_canvas.set_global(new_state, selector)

    // Create the picture
    let picture = view(new_state)

    // Render the picture on the canvas
    impl_canvas.reset(ctx)
    display_on_rendering_context(picture, ctx, default_drawing_state)
    impl_canvas.setup_request_animation_frame(
      // call myself
      get_tick_func(ctx, view, update, selector),
    )
  }
}

/// As an alternative to `display_on_canvas` you can use this web components API to
/// display your pictures. This may be especially convenient when using a front-end
/// framework such as Lustre.
///
/// After calling this function you will be able to use the element `paint-canvas`:
/// ```html
/// <paint-canvas></paint-canvas>
/// <script>
///   const myCanvas = document.querySelector("paint-canvas");
///   // When the `picture` property is set to a `Picture` object that picture
///   // will be displayed on the canvas.
///   myCanvas.picture = ...;
/// </script>
/// ```
///
/// A more detailed example for using this API together with Luster can be found in [this GitHub Gist](https://gist.github.com/adelhult/03c5916df891a06bec706e6f0842cd91).
pub fn define_web_component() -> Nil {
  impl_canvas.define_web_component()
  // somewhat of an ugly hack, but the setter for the web component will need to call
  // `display_on_rendering_context` when the picture property changes. Therefore we
  // bind this function to the window object so we can access it from the JS side of things.
  impl_canvas.set_global(
    fn(picture, ctx) {
      display_on_rendering_context(picture, ctx, default_drawing_state)
    },
    "display_on_rendering_context_with_default_drawing_state",
  )
}

/// Display a picture on a HTML canvas element
/// (specified by some [CSS Selector](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_selectors)).
///
/// Note: this function may only be called once the page has loaded and the
/// document objects is available.
pub fn display_on_canvas(init: fn(CanvasConfig) -> Picture, selector: String) {
  let ctx = impl_canvas.get_rendering_context(selector)
  impl_canvas.reset(ctx)
  let picture =
    init(CanvasConfig(impl_canvas.get_width(ctx), impl_canvas.get_height(ctx)))
  display_on_rendering_context(picture, ctx, default_drawing_state)
}

/// Additional state used when drawing
/// (note that the fill and stroke color as well as the stroke width
/// is stored inside of the context)
type DrawingState {
  DrawingState(fill: Bool, stroke: Bool)
}

const default_drawing_state = DrawingState(fill: False, stroke: True)

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

    Fill(p, colour) -> {
      impl_canvas.save(ctx)
      impl_canvas.set_fill_colour(ctx, colour.to_css_rgba_string(colour))
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
          impl_canvas.set_stroke_color(ctx, colour.to_css_rgba_string(color))
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
/// display_on_canvas(just(circle(30.0)), "#my_canvas")
/// // instead of...
/// display_on_canvas(fn(_config) { circle(30.0) }, "#my_canvas")
/// ```
pub fn just(picture: Picture) -> fn(a) -> Picture {
  fn(_config) { picture }
}

/// Utility to set the origin in the center of the canvas
pub fn center(picture: Picture) -> fn(CanvasConfig) -> Picture {
  fn(config) {
    let CanvasConfig(width, height) = config
    picture |> translate_xy(width *. 0.5, height *. 0.5)
  }
}
