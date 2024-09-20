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
  /// Triggered when the mouse is moved. Contains
  /// the `x` and `y` value for the mouse position.
  MouseMoved(Float, Float)
  /// Triggered when a mouse button is pressed
  MouseButtonPressed(MouseButton)
  /// Triggered when a mouse button is released.
  ///
  /// Note, on the web you might encounter issues where the
  /// release event for the right mouse button is not triggered
  /// because of the context menu.
  MouseButtonReleased(MouseButton)
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

pub type MouseButton {
  MouseButtonLeft
  MouseButtonRight
  /// The scroll wheel button
  MouseButtonMiddle
}
