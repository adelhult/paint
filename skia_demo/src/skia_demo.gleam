import paint as p
import paint/skia

pub fn main() {
  let picture = p.circle(50.0)

  let width = 200.0
  let height = 200.0

  skia.save_file(picture, skia.Jpeg, "./output/testing.jpg", width:, height:)
  skia.save_file(picture, skia.Png, "./output/testing.png", width:, height:)
  skia.save_file(picture, skia.Webp, "./output/testing.webp", width:, height:)
  skia.save_file(picture, skia.Svg, "./output/testing.svg", width:, height:)
  skia.save_file(
    picture,
    skia.Pdf(
      metadata: skia.PdfMetadata(
        ..skia.pdf_metadata_defaults,
        title: "My cool picture",
      ),
    ),
    "./output/testing2.pdf",
    width:,
    height:,
  )
}
