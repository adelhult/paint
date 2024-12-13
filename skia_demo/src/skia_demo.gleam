import gleam/option.{None, Some}
import paint as p
import paint/skia

pub fn main() {
  let picture =
    p.circle(50.0)
    |> p.translate_xy(100.0, 100.0)
    |> p.fill(p.colour_rgb(0, 100, 200))
    |> p.concat(p.text("Hello world!", 40) |> p.translate_y(50.0))

  let width = 200
  let height = 200

  skia.save_file(picture, skia.Jpeg(width:, height:), "./output/testing.jpg")
  skia.save_file(picture, skia.Png(width:, height:), "./output/testing.png")
  skia.save_file(picture, skia.Webp(width:, height:), "./output/testing.webp")
  skia.save_file(picture, skia.Svg(width:, height:), "./output/testing.svg")
  skia.save_file(
    picture,
    skia.Pdf(
      width:,
      height:,
      metadata: skia.PdfMetadata(
        ..skia.pdf_metadata_defaults,
        title: Some("Hej"),
      ),
    ),
    "./output/testing.pdf",
  )
}
