pub type RenderingContext2D

@external(javascript, "./canvas_bindings.mjs", "get_rendering_context")
pub fn get_rendering_context(id: String) -> RenderingContext2D

@external(javascript, "./canvas_bindings.mjs", "reset")
pub fn reset(ctx: RenderingContext2D) -> Nil

@external(javascript, "./canvas_bindings.mjs", "save")
pub fn save(ctx: RenderingContext2D) -> Nil

@external(javascript, "./canvas_bindings.mjs", "restore")
pub fn restore(ctx: RenderingContext2D) -> Nil

@external(javascript, "./canvas_bindings.mjs", "translate")
pub fn translate(ctx: RenderingContext2D, x: Float, y: Float) -> Nil

@external(javascript, "./canvas_bindings.mjs", "scale")
pub fn scale(ctx: RenderingContext2D, x: Float, y: Float) -> Nil

@external(javascript, "./canvas_bindings.mjs", "rotate")
pub fn rotate(ctx: RenderingContext2D, radians: Float) -> Nil

@external(javascript, "./canvas_bindings.mjs", "reset_transform")
pub fn reset_transform(ctx: RenderingContext2D) -> Nil

@external(javascript, "./canvas_bindings.mjs", "set_fill_color")
pub fn set_fill_color(ctx: RenderingContext2D, css_color: String) -> Nil

@external(javascript, "./canvas_bindings.mjs", "set_stroke_color")
pub fn set_stroke_color(ctx: RenderingContext2D, css_color: String) -> Nil

@external(javascript, "./canvas_bindings.mjs", "set_line_width")
pub fn set_line_width(ctx: RenderingContext2D, width: Float) -> Nil

@external(javascript, "./canvas_bindings.mjs", "fill_rect")
pub fn fill_rect(ctx: RenderingContext2D) -> Nil

@external(javascript, "./canvas_bindings.mjs", "arc")
pub fn arc(
  ctx: RenderingContext2D,
  radius: Float,
  start: Float,
  end: Float,
  fill: Bool,
  stroke: Bool,
) -> Nil

@external(javascript, "./canvas_bindings.mjs", "text")
pub fn text(ctx: RenderingContext2D, text: String, style: String) -> Nil
