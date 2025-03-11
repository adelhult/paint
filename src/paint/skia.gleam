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

import paint/internal/draw
import paint/internal/impl_skia
import paint/internal/types.{type Picture}

/// The format and configuration
pub type Format {
  Png
  Jpeg
  Webp
  Svg
  Pdf(metadata: PdfMetadata)
}

/// Additional metadata for a PDF document.
/// For more details please see the [Skia documentation](https://api.skia.org/structSkPDF_1_1Metadata.html).
/// To construct a PdfMetadata value without bothering setting every value, please make use of `pdf_metadata_defaults`:
/// ```
/// PdfMetadata(..pdf_metadata_defaults, title: Some("My cool picture"))
/// ```
pub type PdfMetadata {
  PdfMetadata(
    title: String,
    author: String,
    subject: String,
    keywords: String,
    creator: String,
    producer: String,
    // FIXME: Seems like these dates are broken in the deno skia canvas library?
    // /// This string is expected to be a JavaScript [datestring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date#datestring),
    // /// for example: `October 21 2015 07:28`.
    //creation: Option(String),
    // /// This string is expected to be a JavaScript [datestring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date#datestring),
    // /// for example: `October 21 2015 07:28`.
    //modified: Option(String),
    pdfa: Bool,
    encoding_quality: Int,
  )
}

pub const pdf_metadata_defaults: PdfMetadata = PdfMetadata(
  title: "",
  author: "",
  subject: "",
  keywords: "",
  creator: "",
  producer: "",
  pdfa: False,
  encoding_quality: 0,
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

pub fn save_file(
  picture: Picture,
  format: Format,
  path: String,
  width width: Int,
  height height: Int,
) {
  case format {
    Jpeg | Png | Webp ->
      create_image(width, height, format_to_string(format), picture, path)
    Svg -> create_svg(width, height, picture, path)
    Pdf(metadata) -> create_pdf(width, height, metadata, picture, path)
  }
}

fn create_pdf(
  width: Int,
  height: Int,
  metadata: PdfMetadata,
  picture: Picture,
  path: String,
) -> Nil {
  let PdfMetadata(
    title,
    author,
    subject,
    keywords,
    creator,
    producer,
    //creation,
    //modified,
    pdfa,
    encoding_quality,
  ) = metadata

  let doc =
    impl_skia.pdf_create(
      title,
      author,
      subject,
      keywords,
      creator,
      producer,
      //creation,
      //modified,
      pdfa,
      encoding_quality,
    )
  let ctx = impl_skia.pdf_new_page(doc, width, height)
  draw.display_on_rendering_context(picture, ctx, draw.default_drawing_state)
  impl_skia.pdf_end_page(doc)
  impl_skia.pdf_save(doc, path)
}

fn create_image(
  width: Int,
  height: Int,
  format_string: String,
  picture: Picture,
  path: String,
) -> Nil {
  let canvas = impl_skia.canvas_create(width, height)
  let ctx = impl_skia.get_rendering_context(canvas)
  draw.display_on_rendering_context(picture, ctx, draw.default_drawing_state)
  impl_skia.canvas_save(canvas, format_string, path)
}

fn create_svg(width: Int, height: Int, picture: Picture, path: String) -> Nil {
  let canvas = impl_skia.svg_canvas_create(width, height)
  let ctx = impl_skia.svg_get_rendering_context(canvas)
  draw.display_on_rendering_context(picture, ctx, draw.default_drawing_state)
  let completed_canvas = impl_skia.svg_canvas_complete(canvas)
  impl_skia.svg_canvas_save(completed_canvas, path)
}
