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
