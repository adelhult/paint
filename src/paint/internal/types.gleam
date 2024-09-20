import gleam_community/colour.{type Colour}

pub type Picture {
  // Shapes
  Blank
  Polygon(List(Vec2), closed: Bool)
  Arc(radius: Float, start: Angle, end: Angle)
  Text(text: String, style: FontProperties)
  // TODO: Bitmap images
  // Styling
  Fill(Picture, Colour)
  Stroke(Picture, StrokeProperties)
  // Transform
  Translate(Picture, Vec2)
  Scale(Picture, Vec2)
  Rotate(Picture, Angle)
  // Combine
  Combine(List(Picture))
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
