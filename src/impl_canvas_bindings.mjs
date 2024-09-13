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

export function get_width(ctx) {
  return ctx.canvas.clientWidth;
}

export function get_height(ctx) {
  return ctx.canvas.clientHeight;
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

export function mouse_buttons(event) {
  return event.buttons;
}

export function reset(ctx) {
  ctx.reset();
}

export function arc(ctx, radius, start, end, fill, stroke) {
  ctx.beginPath();
  ctx.arc(0, 0, radius, start, end);
  if (fill) {
    ctx.fill();
  }
  if (stroke) {
    ctx.stroke();
  }
}

export function polygon(ctx, points, closed, fill, stroke) {
  ctx.beginPath();
  ctx.moveTo(0, 0);
  let started = false;
  for (const point of points) {
    let x = point[0];
    let y = point[1];
    if (started) {
      ctx.lineTo(x, y);
    } else {
      ctx.moveTo(x, y);
      started = true;
    }
  }

  if (closed) {
    ctx.closePath();
  }

  if (fill && closed) {
    ctx.fill();
  }

  if (stroke) {
    ctx.stroke();
  }
}

export function text(ctx, text, style) {
  ctx.font = style;
  ctx.fillText(text, 0, 0);
}

export function save(ctx) {
  ctx.save();
}

export function restore(ctx) {
  ctx.restore();
}

export function set_fill_colour(ctx, css_colour) {
  ctx.fillStyle = css_colour;
}

export function set_stroke_color(ctx, css_color) {
  ctx.strokeStyle = css_color;
}

export function set_line_width(ctx, width) {
  ctx.lineWidth = width;
}

export function translate(ctx, x, y) {
  ctx.translate(x, y);
}

export function scale(ctx, x, y) {
  ctx.scale(x, y);
}

export function rotate(ctx, radians) {
  ctx.rotate(radians);
}

export function reset_transform(ctx) {
  ctx.resetTransform();
}
