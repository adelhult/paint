//// A HTML canvas backend that can be used for displaying
//// your `Picture`s. There are three different ways of doing so:
//// - `display` (provide a picture and a CSS selector to some canvas element)
//// - `define_web_component` (an alternative to `display` using custom web components, useful if you are using a web framework like Lustre)
//// - `interact` (allows you to make animations and interactive programs)

import gleam/int
import gleam/option.{type Option, None, Some}
import gleam_community/colour
import paint.{translate_xy}
import paint/event.{type Event}
import paint/internal/impl_canvas
import paint/internal/types.{
  type Picture, Arc, Blank, Combine, Fill, FontProperties, NoStroke, Polygon,
  Radians, Rotate, Scale, SolidStroke, Stroke, Text, Translate,
}

/// The configuration of the "canvas"
pub type Config {
  Config(width: Float, height: Float)
}

/// Display a picture on a HTML canvas element
/// (specified by some [CSS Selector](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_selectors)).
/// ```
/// canvas.display(fn (_: canvas.Config) { circle(50.0) }, "#mycanvas")
/// ```
pub fn display(init: fn(Config) -> Picture, selector: String) {
  let ctx = impl_canvas.get_rendering_context(selector)
  impl_canvas.reset(ctx)
  let picture =
    init(Config(impl_canvas.get_width(ctx), impl_canvas.get_height(ctx)))
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

/// Animations, interactive applications and tiny games can be built using the
/// `interact` function. It roughly follows the so-called [Elm architecture](https://guide.elm-lang.org/architecture/).
/// Here is a short example:
/// ```
/// type State =
///   Int
///
/// fn init(_: canvas.Config) -> State {
///   0
/// }
///
/// fn update(state: State, event: event.Event) -> State {
///   case event {
///     event.Tick(_) -> state + 1
///     _ -> state
///   }
/// }
///
/// fn view(state: State) -> Picture {
///   paint.circle(int.to_float(state))
/// }
///
/// fn main() {
///   interact(init, update, view, "#mycanvas")
/// }
/// ```
pub fn interact(
  init: fn(Config) -> state,
  update: fn(state, Event) -> state,
  view: fn(state) -> Picture,
  selector: String,
) {
  let ctx = impl_canvas.get_rendering_context(selector)
  let initial_state =
    init(Config(impl_canvas.get_width(ctx), impl_canvas.get_height(ctx)))

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
  create_key_handler("keydown", event.KeyboardPressed)
  create_key_handler("keyup", event.KeyboardRelased)

  // Handle mouse movement
  impl_canvas.setup_input_handler(
    "mousemove",
    fn(event: impl_canvas.MouseEvent) {
      let #(x, y) = impl_canvas.mouse_pos(ctx, event)
      let new_state =
        update(impl_canvas.get_global(selector), event.MouseMoved(x, y))
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
          True -> trigger_update(event.MouseButtonLeft)
          False -> Nil
        }
        case check_button(1) {
          True -> trigger_update(event.MouseButtonRight)
          False -> Nil
        }
        case check_button(2) {
          True -> trigger_update(event.MouseButtonMiddle)
          False -> Nil
        }

        Nil
      },
    )
  }
  create_mouse_button_handler("mousedown", event.MouseButtonPressed, True)
  create_mouse_button_handler("mouseup", event.MouseButtonReleased, False)

  impl_canvas.setup_request_animation_frame(get_tick_func(
    ctx,
    view,
    update,
    selector,
  ))
}

fn parse_key_code(key_code: Int) -> Option(event.Key) {
  case key_code {
    32 -> Some(event.KeySpace)
    37 -> Some(event.KeyLeftArrow)
    38 -> Some(event.KeyUpArrow)
    39 -> Some(event.KeyRightArrow)
    40 -> Some(event.KeyDownArrow)
    87 -> Some(event.KeyW)
    65 -> Some(event.KeyA)
    83 -> Some(event.KeyS)
    68 -> Some(event.KeyD)
    90 -> Some(event.KeyZ)
    88 -> Some(event.KeyX)
    67 -> Some(event.KeyC)
    18 -> Some(event.KeyEnter)
    27 -> Some(event.KeyEscape)
    8 -> Some(event.KeyBackspace)
    _ -> None
  }
}

// Gleam does not have recursive let bindings, so I need
// to do this workaround...
fn get_tick_func(ctx, view, update, selector) {
  fn(time) {
    let current_state = impl_canvas.get_global(selector)

    // Trigger a tick event before drawing
    let new_state = update(current_state, event.Tick(time))
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

/// If you are using [Lustre](https://github.com/lustre-labs/lustre) or some other framework to build
/// your web application you may prefer to use the [web components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components) API
/// and the `define_web_component` function.
/// ```
/// // Call this function to register a custom HTML element <paint-canvas>
/// canvas.define_web_component()
/// // You can then display your picture by setting the "picture"
/// // property on the element.
///
/// // In Lustre it would look something like this:
/// let my_picture = circle(50.0)
/// element(
///   "paint-canvas",
///    [
///        attribute.property("picture", my_picture),
///        attribute.width(500),
///        attribute.height(300),
///        attribute.style([#("background", "#eee")]),
///     ],
///     [],
/// )
/// ```
/// A more detailed example for using this API together with Lustre can be found in [this GitHub Gist](https://gist.github.com/adelhult/03c5916df891a06bec706e6f0842cd91).
///
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

/// Utility to set the origin in the center of the canvas
pub fn center(picture: Picture) -> fn(Config) -> Picture {
  fn(config) {
    let Config(width, height) = config
    picture |> translate_xy(width *. 0.5, height *. 0.5)
  }
}
