//// Internal bindings for the HTML canvas backend.

import paint/internal/impl_rendering_ctx.{type RenderingContext2D}

@external(javascript, "./impl_canvas.ffi.mjs", "define_web_component")
pub fn define_web_component() -> Nil

@external(javascript, "./impl_canvas.ffi.mjs", "setup_request_animation_frame")
pub fn setup_request_animation_frame(callback: fn(Float) -> Nil) -> Nil

@external(javascript, "./impl_canvas.ffi.mjs", "get_rendering_context")
pub fn get_rendering_context(selector: String) -> RenderingContext2D

@external(javascript, "./impl_canvas.ffi.mjs", "setup_input_handler")
pub fn setup_input_handler(event: String, callback: fn(event) -> Nil) -> Nil

pub type KeyboardEvent

@external(javascript, "./impl_canvas.ffi.mjs", "get_key_code")
pub fn get_key_code(event: KeyboardEvent) -> Int

pub type MouseEvent

@external(javascript, "./impl_canvas.ffi.mjs", "mouse_pos")
pub fn mouse_pos(ctx: RenderingContext2D, event: MouseEvent) -> #(Float, Float)

@external(javascript, "./impl_canvas.ffi.mjs", "check_mouse_button")
pub fn check_mouse_button(
  event: MouseEvent,
  previous_event: MouseEvent,
  button_index: Int,
  check_pressed check_pressed: Bool,
) -> Bool

@external(javascript, "./impl_canvas.ffi.mjs", "set_global")
pub fn set_global(state: state, id: String) -> Nil

@external(javascript, "./impl_canvas.ffi.mjs", "get_global")
pub fn get_global(id: String) -> state
