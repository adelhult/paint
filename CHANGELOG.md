# 0.3.0 (WIP)
- Breaking: The `Event` type now contains a `EventMouseMovement`, used to capture mouse movement.
- Breaking: More `Key`s trigger events (WASD, XYZ, backspace, enter, escape).
- Breaking: The constructors in `Event` and `Key` has been renamed with an added prefix. (not super happy with this, might introduce seperate namespaces `paint.key` and `paint.event` instead).

# 0.2.2
- Fix: Use display inline-block for the web component.

# 0.2.1
- Fix: Support width/height properties for the web component API (instead of just attributes).

# 0.2.0
- Addition: Web component API `<paint-canvas></paint-canvas>`.
- Breaking: Replace the colour type with `Colour` from gleam_community_colour.
- Breaking: Replace `color_rgb` with `colour_rgb` and `colour_hex`.
- Breaking: `display_on_canvas` and `interact_on_canvas` now take any css selector instead of a id.

# 0.1.0
Initial release
