# 0.3.0
- Breaking: A big refactor of the code base. The canvas backend now lives in `paint/canvas`, the functions has been renamed appropriately (`display_on_canvas` => `canvas.display`). The `Key` and `Event` types has been moved to `paint/event`.
- Addition/Breaking: More `Event`s for mouse movement and mouse buttons.
- Addition/Breaking: More `Key`s (WASD, XYZ, backspace, enter, escape).

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
