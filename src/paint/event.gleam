//// This module contains events that can be triggered when
//// building interactive applications.
////
//// See `paint/canvas` and the `canvas.interact` function for a
//// practical example of how this is used.

pub type Event {
  /// Triggered before drawing. Contains the number of milliseconds elapsed.
  Tick(Float)
  /// Triggered when a key is pressed
  KeyboardPressed(Key)
  /// Triggered when a key is released
  KeyboardRelased(Key)
  /// Triggered when a pointer (mouse or touch input) is moved
  ///
  /// Contains the x and y position of the pointer and the pointer_id, which
  /// can be ignored unless you are supporting multi-touch.
  ///
  /// pointer_id will be unique for each pointer (mouse, finger, pen, etc) that
  /// is simultaneously used with the device.
  PointerMoved(x: Float, y: Float, pointer_id: Int)
  /// Triggered when a pointer button is pressed
  ///
  /// Contains the x and y position of the pointer, the button that is being
  /// pressed and the pointer_id, which can be ignored unless you are
  /// supporting multi-touch.
  ///
  /// pointer_id will be unique for each pointer (mouse, finger, pen, etc) that
  /// is simultaneously used with the device.
  PointerPressed(x: Float, y: Float, button: PointerButton, pointer_id: Int)
  /// Triggered when a pointer button is released
  ///
  /// Note, on the web you might encounter issues where the
  /// release event for the right mouse button is not triggered
  /// because of the context menu.
  PointerReleased(x: Float, y: Float, button: PointerButton, pointer_id: Int)
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

pub type PointerButton {
  PointerButtonPrimary
  PointerButtonSecondary
  PointerButtonOther(Int)
}
