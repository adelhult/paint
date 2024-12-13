class PaintCanvas extends HTMLElement {
  // Open an issue if you are in need of any other attributes :)
  static observedAttributes = ["width", "height", "style"];

  constructor() {
    super();
    // Create a canvas
    this.canvas = document.createElement("canvas");
    const style = document.createElement("style");
    style.textContent = `
      :host {
        display: inline-block;
      }
    `;
    this.shadow = this.attachShadow({ mode: "open" });
    this.shadow.appendChild(style);
    this.shadow.appendChild(this.canvas);
    this.ctx = this.canvas.getContext("2d");
  }

  // forward any given attributes to the canvas
  attributeChangedCallback(name, _oldValue, newValue) {
    this.canvas.setAttribute(name, newValue);
  }

  set picture(value) {
    this.ctx.reset();
    const display =
      window.PAINT_STATE[
        "display_on_rendering_context_with_default_drawing_state"
      ];
    display(value, this.ctx);
  }

  set width(value) {
    this.canvas.width = value;
  }

  set height(value) {
    this.canvas.height = value;
  }

  get width() {
    return this.canvas.width;
  }

  get height() {
    return this.canvas.height;
  }
}

export function define_web_component() {
  window.customElements.define("paint-canvas", PaintCanvas);
}

export function get_rendering_context(selector) {
  // TODO: Handle the case where the canvas element is not found.
  return document.querySelector(selector).getContext("2d");
}

export function setup_request_animation_frame(callback) {
  window.requestAnimationFrame((time) => {
    callback(time);
  });
}

export function setup_input_handler(event_name, callback) {
  window.addEventListener(event_name, callback);
}

export function get_key_code(event) {
  return event.keyCode;
}

export function set_global(state, id) {
  if (typeof window.PAINT_STATE == "undefined") {
    window.PAINT_STATE = {};
  }
  window.PAINT_STATE[id] = state;
}

export function get_global(id) {
  return window.PAINT_STATE[id];
}

// Based on https://stackoverflow.com/questions/17130395/real-mouse-position-in-canvas
export function mouse_pos(ctx, event) {
  // Calculate the scaling of the canvas vs its content
  const rect = ctx.canvas.getBoundingClientRect();
  const scaleX = ctx.canvas.width / rect.width;
  const scaleY = ctx.canvas.height / rect.height;

  return [
    (event.clientX - rect.left) * scaleX,
    (event.clientY - rect.top) * scaleY,
  ];
}

// if check_pressed is true, the function will return true if the button was pressed
// if check_pressed is false, the function will return true if the button was released
export function check_mouse_button(
  event,
  previous_event,
  button_index,
  check_pressed,
) {
  let previous_buttons = previous_event?.buttons ?? 0;
  let current_buttons = event.buttons;

  // ~001 &&
  //  011
  //  -----
  //  010 found the newly pressed!
  //
  //   011 &&
  //  ~001
  //   -----
  //   010 found the newly released!
  if (check_pressed) {
    previous_buttons = ~previous_buttons;
  } else {
    current_buttons = ~current_buttons;
  }

  let button = previous_buttons & current_buttons & (1 << button_index);
  return !!button;
}
