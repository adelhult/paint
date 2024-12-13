//// A backend using [Deno Skia canvas](https://github.com/DjDeveloperr/skia_canvas) that allows
//// you to create images, PDFs and SVGs from a `Picture`.
////
//// To make use of this backend, make sure you are targeting javascript and using the Deno runtime
//// as well as enabling the relevant permissions. Your `gleam.toml` file should
//// look something like this:
//// ```toml
//// target = "javascript"
////
//// [javascript]
//// runtime = "deno"
////
//// [javascript.deno]
//// allow_ffi = true
//// allow_env = true
//// allow_read = true
//// ```

import gleam/option.{type Option, None}
import paint/internal/draw
import paint/internal/impl_skia
import paint/internal/types.{type Picture}

/// The format and configuration
pub type Format {
  Png(width: Int, height: Int)
  Jpeg(width: Int, height: Int)
  Webp(width: Int, height: Int)
  Svg(width: Int, height: Int)
  Pdf(width: Int, height: Int, metadata: PdfMetadata)
}

/// Additional metadata for a PDF document.
/// For more details please see the [Skia documentation](https://api.skia.org/structSkPDF_1_1Metadata.html)
pub type PdfMetadata {
  PdfMetadata(
    title: Option(String),
    author: Option(String),
    subject: Option(String),
    keywords: Option(String),
    creator: Option(String),
    producer: Option(String),
    /// This string is expected to be a JavaScript [datestring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date#datestring).
    creation: Option(String),
    /// This string is expected to be a JavaScript [datestring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date#datestring).
    modified: Option(String),
    pdfa: Option(Bool),
    encoding_quality: Option(Int),
  )
}

pub const pdf_metadata_defaults: PdfMetadata = PdfMetadata(
  title: None,
  author: None,
  subject: None,
  keywords: None,
  creator: None,
  producer: None,
  creation: None,
  modified: None,
  pdfa: None,
  encoding_quality: None,
)

fn format_to_string(format: Format) -> String {
  case format {
    Jpeg(..) -> "jpeg"
    Png(..) -> "png"
    Webp(..) -> "webp"
    Svg(..) -> "svg"
    Pdf(..) -> "pdf"
  }
}

pub fn save_file(picture: Picture, format: Format, path: String) {
  case format {
    Jpeg(width, height) | Png(width, height) | Webp(width, height) -> {
      let canvas = impl_skia.canvas_create(width, height)
      let ctx = impl_skia.get_rendering_context(canvas)
      draw.display_on_rendering_context(
        picture,
        ctx,
        draw.default_drawing_state,
      )
      impl_skia.canvas_save(canvas, format_to_string(format), path)
    }
    Svg(width, height) -> {
      let canvas = impl_skia.svg_canvas_create(width, height)
      let ctx = impl_skia.svg_get_rendering_context(canvas)
      draw.display_on_rendering_context(
        picture,
        ctx,
        draw.default_drawing_state,
      )
      let completed_canvas = impl_skia.svg_canvas_complete(canvas)
      impl_skia.svg_canvas_save(completed_canvas, path)
    }
    Pdf(width, height, metadata) -> {
      Nil
    }
  }
}
