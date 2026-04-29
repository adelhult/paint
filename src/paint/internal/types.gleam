import gleam_community/colour.{type Colour}

pub type Picture {
  // Shapes
  Blank
  Polygon(List(Vec2), closed: Bool)
  Arc(radius: Float, start: Angle, end: Angle)
  Text(text: String, style: FontProperties)
  ImageRef(Image, width_px: Int, height_px: Int)
  // Styling
  // TODO: font
  Fill(Picture, Colour)
  Stroke(Picture, StrokeProperties)
  ImageScalingBehaviour(Picture, ImageScalingBehaviour)
  // Transform
  Translate(Picture, Vec2)
  Scale(Picture, Vec2)
  Rotate(Picture, Angle)
  // Combine
  Combine(List(Picture))
}

// The ID for an image
// Invariant: the image object is assumed to already be created and stored somewhere (like the PAINT_STATE for the canvas backend)
pub type Image {
  Image(id: String)
}

pub type ImageScalingBehaviour {
  ScalingSmooth
  ScalingPixelated
}

pub type StrokeProperties {
  NoStroke
  DashedStroke(Colour, width: Float, dashes: List(Float))
}

pub type FontProperties {
  FontProperties(size_px: Int, font_family: String)
}

pub type Angle {
  Radians(Float)
}

pub type Vec2 =
  #(Float, Float)
