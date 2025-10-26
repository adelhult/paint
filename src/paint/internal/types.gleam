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
  // Transform
  Translate(Picture, Vec2)
  Scale(Picture, Vec2)
  Rotate(Picture, Angle)
  // Combine
  Combine(List(Picture))
}

// TODO: if we add other backends way may want to extend this type
// with some more information. Or even add a phantom type...
pub type Image {
  Image(id: String)
}

pub type StrokeProperties {
  NoStroke
  SolidStroke(Colour, Float)
}

pub type FontProperties {
  FontProperties(size_px: Int, font_family: String)
}

pub type Angle {
  Radians(Float)
}

pub type Vec2 =
  #(Float, Float)
