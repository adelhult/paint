//// Internal "low level" bindings to the JavaScript canvas API

pub type RenderingContext2D

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "get_width")
pub fn get_width(ctx: RenderingContext2D) -> Float

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "get_height")
pub fn get_height(ctx: RenderingContext2D) -> Float

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "reset")
pub fn reset(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "save")
pub fn save(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "restore")
pub fn restore(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "translate")
pub fn translate(ctx: RenderingContext2D, x: Float, y: Float) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "scale")
pub fn scale(ctx: RenderingContext2D, x: Float, y: Float) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "rotate")
pub fn rotate(ctx: RenderingContext2D, radians: Float) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "reset_transform")
pub fn reset_transform(ctx: RenderingContext2D) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "set_fill_colour")
pub fn set_fill_colour(ctx: RenderingContext2D, css_colour: String) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "set_stroke_color")
pub fn set_stroke_color(ctx: RenderingContext2D, css_color: String) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "set_line_width")
pub fn set_line_width(ctx: RenderingContext2D, width: Float) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "arc")
pub fn arc(
  ctx: RenderingContext2D,
  radius: Float,
  start: Float,
  end: Float,
  fill: Bool,
  stroke: Bool,
) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "polygon")
pub fn polygon(
  ctx: RenderingContext2D,
  points: List(#(Float, Float)),
  closed: Bool,
  fill: Bool,
  stroke: Bool,
) -> Nil

@external(javascript, "./impl_rendering_ctx.ffi.mjs", "text")
pub fn text(ctx: RenderingContext2D, text: String, style: String) -> Nil
