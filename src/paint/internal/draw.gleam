//// The API for the Canvas 2d rendering context is used both for the web canvas backend and
//// and the skia backend.

import gleam/int
import gleam_community/colour
import paint/internal/impl_rendering_ctx
import paint/internal/types.{
  type Picture, Arc, Blank, Combine, Fill, FontProperties, NoStroke, Polygon,
  Radians, Rotate, Scale, SolidStroke, Stroke, Text, Translate,
}

/// Additional state used when drawing
/// (note that the fill and stroke color as well as the stroke width
/// is stored inside of the context)
pub type DrawingState {
  DrawingState(fill: Bool, stroke: Bool)
}

pub const default_drawing_state = DrawingState(fill: False, stroke: True)

pub fn display_on_rendering_context(
  picture: Picture,
  ctx: impl_rendering_ctx.RenderingContext2D,
  state: DrawingState,
) {
  case picture {
    Blank -> Nil

    Text(text, properties) -> {
      let FontProperties(size_px, font_family) = properties
      impl_rendering_ctx.save(ctx)
      impl_rendering_ctx.text(
        ctx,
        text,
        int.to_string(size_px) <> "px " <> font_family,
      )
      impl_rendering_ctx.restore(ctx)
    }

    Polygon(points, closed) -> {
      impl_rendering_ctx.polygon(ctx, points, closed, state.fill, state.stroke)
    }

    Arc(radius, start, end) -> {
      let Radians(start_radians) = start
      let Radians(end_radians) = end
      impl_rendering_ctx.arc(
        ctx,
        radius,
        start_radians,
        end_radians,
        state.fill,
        state.stroke,
      )
    }

    Fill(p, colour) -> {
      impl_rendering_ctx.save(ctx)
      impl_rendering_ctx.set_fill_colour(ctx, colour.to_css_rgba_string(colour))
      display_on_rendering_context(p, ctx, DrawingState(..state, fill: True))
      impl_rendering_ctx.restore(ctx)
    }

    Stroke(p, stroke) -> {
      case stroke {
        NoStroke ->
          display_on_rendering_context(
            p,
            ctx,
            DrawingState(..state, stroke: False),
          )
        SolidStroke(color, width) -> {
          impl_rendering_ctx.save(ctx)
          impl_rendering_ctx.set_stroke_color(
            ctx,
            colour.to_css_rgba_string(color),
          )
          impl_rendering_ctx.set_line_width(ctx, width)
          display_on_rendering_context(
            p,
            ctx,
            DrawingState(..state, stroke: True),
          )
          impl_rendering_ctx.restore(ctx)
        }
      }
    }

    Translate(p, vec) -> {
      let #(x, y) = vec
      impl_rendering_ctx.save(ctx)
      impl_rendering_ctx.translate(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      impl_rendering_ctx.restore(ctx)
    }

    Scale(p, vec) -> {
      let #(x, y) = vec
      impl_rendering_ctx.save(ctx)
      impl_rendering_ctx.scale(ctx, x, y)
      display_on_rendering_context(p, ctx, state)
      impl_rendering_ctx.restore(ctx)
    }

    Rotate(p, angle) -> {
      let Radians(rad) = angle
      impl_rendering_ctx.save(ctx)
      impl_rendering_ctx.rotate(ctx, rad)
      display_on_rendering_context(p, ctx, state)
      impl_rendering_ctx.restore(ctx)
    }

    Combine(pictures) -> {
      case pictures {
        [] -> Nil
        [p, ..ps] -> {
          display_on_rendering_context(p, ctx, state)
          display_on_rendering_context(Combine(ps), ctx, state)
        }
      }
    }
  }
}
