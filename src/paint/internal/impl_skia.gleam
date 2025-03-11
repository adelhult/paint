import paint/internal/impl_rendering_ctx.{type RenderingContext2D}

pub type Canvas

pub type SvgCanvas

pub type SvgCanvasCompleted

pub type PdfDocument

@external(javascript, "./impl_skia.ffi.mjs", "get_rendering_context")
pub fn get_rendering_context(canvas: Canvas) -> RenderingContext2D

@external(javascript, "./impl_skia.ffi.mjs", "get_rendering_context")
pub fn svg_get_rendering_context(canvas: SvgCanvas) -> RenderingContext2D

@external(javascript, "./impl_skia.ffi.mjs", "canvas_create")
pub fn canvas_create(width: Int, height: Int) -> Canvas

@external(javascript, "./impl_skia.ffi.mjs", "canvas_save")
pub fn canvas_save(canvas: Canvas, format: String, path: String) -> Nil

@external(javascript, "./impl_skia.ffi.mjs", "svg_canvas_create")
pub fn svg_canvas_create(width: Int, height: Int) -> SvgCanvas

@external(javascript, "./impl_skia.ffi.mjs", "svg_canvas_complete")
pub fn svg_canvas_complete(canvas: SvgCanvas) -> SvgCanvasCompleted

@external(javascript, "./impl_skia.ffi.mjs", "svg_canvas_save")
pub fn svg_canvas_save(canvas: SvgCanvasCompleted, path: String) -> Nil

@external(javascript, "./impl_skia.ffi.mjs", "pdf_create")
pub fn pdf_create(
  title: String,
  author: String,
  subject: String,
  keywords: String,
  creator: String,
  producer: String,
  //creation: Option(String),
  //modified: Option(String),
  pdfa: Bool,
  encoding_quality: Int,
) -> PdfDocument

@external(javascript, "./impl_skia.ffi.mjs", "pdf_new_page")
pub fn pdf_new_page(
  pdf: PdfDocument,
  width: Int,
  height: Int,
) -> RenderingContext2D

@external(javascript, "./impl_skia.ffi.mjs", "pdf_end_page")
pub fn pdf_end_page(pdf: PdfDocument) -> Nil

@external(javascript, "./impl_skia.ffi.mjs", "pdf_save")
pub fn pdf_save(pdf: PdfDocument, path: String) -> Nil
