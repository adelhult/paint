pub type RenderingContext2D

// TODO: forward the timestamp from the callback
@external(javascript, "./impl_canvas_bindings.mjs", "setup_request_animation_frame")
pub fn setup_request_animation_frame(callback: fn() -> Nil) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "setup_key_handler")
pub fn setup_key_handler(event: String, callback: fn(Int) -> Nil) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "get_rendering_context")
pub fn get_rendering_context(id: String) -> RenderingContext2D

@external(javascript, "./impl_canvas_bindings.mjs", "get_width")
pub fn get_width(ctx: RenderingContext2D) -> Float

@external(javascript, "./impl_canvas_bindings.mjs", "get_height")
pub fn get_height(ctx: RenderingContext2D) -> Float

@external(javascript, "./impl_canvas_bindings.mjs", "store_state")
pub fn store_state(state: state, id: String) -> Nil

@external(javascript, "./impl_canvas_bindings.mjs", "get_state")
pub fn get_state(id: String) -> state

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

@external(javascript, "./impl_canvas_bindings.mjs", "set_fill_color")
pub fn set_fill_color(ctx: RenderingContext2D, css_color: String) -> Nil

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
