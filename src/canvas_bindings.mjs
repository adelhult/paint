const UNIT_SIZE_PX = 50;

export function get_rendering_context(id) {
  // TODO: Handle the case where the canvas element is not found.
  return document.getElementById(id).getContext("2d");
}

function set_origin(ctx) {
  let x = ctx.canvas.clientWidth * 0.5;
  let y = ctx.canvas.clientHeight * 0.5;
  ctx.translate(x, y);
}

export function reset(ctx) {
  ctx.reset();
  set_origin(ctx);
}

export function fill_rect(ctx) {
  ctx.fillRect(0, 0, UNIT_SIZE_PX, UNIT_SIZE_PX);
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

export function set_fill_color(ctx, css_color) {
  ctx.fillStyle = css_color;
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
  set_origin(ctx);
}
