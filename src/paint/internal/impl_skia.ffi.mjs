import { createCanvas, SvgCanvas, PdfDocument } from "jsr:@gfx/canvas@0.5.6";

export function canvas_create(width, height) {
  return createCanvas(width, height);
}

export function get_rendering_context(canvas) {
  return canvas.getContext("2d");
}

export function canvas_save(canvas, format, path) {
  canvas.save(path);
}

export function svg_canvas_complete(canvas) {
  canvas.complete();
  return canvas;
}

export function svg_canvas_create(width, height) {
  return new SvgCanvas(width, height);
}

export function svg_canvas_save(canvas, path) {
  canvas.save(path);
}

export function pdf_create(
  title,
  author,
  subject,
  keywords,
  creator,
  producer,
  creation,
  modified,
  pdfa,
  encodingQuality
) {
  return new PdfDocument(metadata, {
    title: title,
    author: author,
    subject: subject,
    keywords: keywords,
    creator: creator,
    producer: producer,
    creation: new Date(creation),
    modified: new Date(modified),
    pdfa: pdfa,
    encodingQuality: encodingQuality,
  });
}

export function pdf_new_page(pdf, w, h) {
  return pdf.newPage(w, h);
}

export function pdf_end_page() {
  pdf.endPage();
}

export function pdf_save(pdf, path) {
  pdf.save(path);
}
