pub type RenderingContext2D

@external(javascript, "./impl_canvas_bindings.mjs", "define_web_component")
pub fn define_web_component() -> Nil

// TODO: forward the timestamp from the callback
@external(javascript, "./impl_canvas_bindings.mjs", "setup_request_animation_frame")
pub fn setup_request_animation_frame(callback: fn(Float) -> Nil) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "get_rendering_context")
pub fn get_rendering_context(selector: String) -> RenderingContext2D

@external(javascript, "./impl_canvas_bindings.mjs", "setup_input_handler")
pub fn setup_input_handler(event: String, callback: fn(event) -> Nil) -> Nil

pub type KeyboardEvent

@external(javascript, "./impl_canvas_bindings.mjs", "get_key_code")
pub fn get_key_code(event: KeyboardEvent) -> Int

pub type MouseEvent

@external(javascript, "./impl_canvas_bindings.mjs", "mouse_pos")
pub fn mouse_pos(ctx: RenderingContext2D, event: MouseEvent) -> #(Float, Float)

@external(javascript, "./impl_canvas_bindings.mjs", "check_mouse_button")
pub fn check_mouse_button(
  event: MouseEvent,
  previous_event: MouseEvent,
  button_index: Int,
  check_pressed check_pressed: Bool,
) -> Bool

@external(javascript, "./impl_canvas_bindings.mjs", "get_width")
pub fn get_width(ctx: RenderingContext2D) -> Float

@external(javascript, "./impl_canvas_bindings.mjs", "get_height")
pub fn get_height(ctx: RenderingContext2D) -> Float

@external(javascript, "./impl_canvas_bindings.mjs", "set_global")
pub fn set_global(state: state, id: String) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "get_global")
pub fn get_global(id: String) -> state

@external(javascript, "./impl_canvas_bindings.mjs", "reset")
pub fn reset(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "save")
pub fn save(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "restore")
pub fn restore(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "translate")
pub fn translate(ctx: RenderingContext2D, x: Float, y: Float) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "scale")
pub fn scale(ctx: RenderingContext2D, x: Float, y: Float) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "rotate")
pub fn rotate(ctx: RenderingContext2D, radians: Float) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "reset_transform")
pub fn reset_transform(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "set_fill_colour")
pub fn set_fill_colour(ctx: RenderingContext2D, css_colour: String) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "set_stroke_color")
pub fn set_stroke_color(ctx: RenderingContext2D, css_color: String) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "set_line_width")
pub fn set_line_width(ctx: RenderingContext2D, width: Float) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "arc")
pub fn arc(
  ctx: RenderingContext2D,
  radius: Float,
  start: Float,
  end: Float,
  fill: Bool,
  stroke: Bool,
) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "polygon")
pub fn polygon(
  ctx: RenderingContext2D,
  points: List(#(Float, Float)),
  closed: Bool,
  fill: Bool,
  stroke: Bool,
) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "text")
pub fn text(ctx: RenderingContext2D, text: String, style: String) -> Nil
