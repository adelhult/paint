import { createCanvas, SvgCanvas, PdfDocument } from "jsr:@gfx/canvas@0.5.6";
import { Error, Ok } from "./../../gleam.mjs";

export function canvas_create(width, height) {
  try {
    return new Ok(createCanvas(width, height));
  } catch (error) {
    return new Error(error.toString());
  }
}

export function get_rendering_context(canvas) {
  try {
    return new Ok(canvas.getContext("2d"));
  } catch (error) {
    return new Error(error.toString());
  }
}

export function canvas_save(canvas, format, path) {
  try {
    return new Ok(canvas.save(path, format));
  } catch (error) {
    return new Error(error.toString());
  }
}

export function svg_canvas_complete(canvas) {
  canvas.complete();
  return canvas;
}

export function svg_canvas_create(width, height) {
  try {
    return new Ok(new SvgCanvas(width, height));
  } catch (error) {
    return new Error(error.toString());
  }
}

export function svg_canvas_save(canvas, path) {
  try {
    return new Ok(canvas.save(path));
  } catch (error) {
    return new Error(error.toString());
  }
}

export function pdf_create(
  title,
  author,
  subject,
  keywords,
  creator,
  producer,
  //creation,
  //modified,
  pdfa,
  encodingQuality,
) {
  try {
    return new Ok(
      new PdfDocument({
        title,
        author,
        subject,
        keywords,
        creator,
        producer,
        pdfa,
        encodingQuality,
      }),
    );
  } catch (error) {
    return new Error(error.toString());
  }
}

export function pdf_new_page(pdf, w, h) {
  try {
    return new Ok(pdf.newPage(w, h));
  } catch (error) {
    return new Error(error.toString());
  }
}

export function pdf_end_page(pdf) {
  try {
    return new Ok(pdf.endPage());
  } catch (error) {
    return new Error(error.toString());
  }
}

export function pdf_save(pdf, path) {
  try {
    return new Ok(pdf.save(path));
  } catch (error) {
    return new Error(error.toString());
  }
}
