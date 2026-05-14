import gleam_community/colour.{type Colour}

pub type Picture {
  // Shapes
  Blank
  Path(List(PathSegment))
  Text(text: String, size_px: Int)
  ImageRef(Image, width_px: Int, height_px: Int)
  // Styling
  Fill(Picture, Colour)
  Stroke(Picture, StrokeProperties)
  ImageScalingBehaviour(Picture, ImageScalingBehaviour)
  FontFamily(Picture, String)
  TextAlign(Picture, TextAlign)
  TextBaseline(Picture, TextBaseline)
  TextDirection(Picture, TextDirection)
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

pub type PathSegment {
  MoveTo(Vec2)
  LineTo(Vec2)
  ArcCentre(
    centre: Vec2,
    radius: Float,
    start_angle: Angle,
    end_angle: Angle,
    counterclockwise: Bool,
  )
  ArcCorner(corner: Vec2, end: Vec2, radius: Float)
  BezierTo(cp1: Vec2, cp2: Vec2, end: Vec2)
}

pub type StrokeProperties {
  NoStroke
  DashedStroke(Colour, width: Float, dashes: List(Float))
}

pub type TextAlign {
  TextAlignStart
  TextAlignEnd
  TextAlignLeft
  TextAlignRight
  TextAlignCenter
}

pub type TextBaseline {
  TextBaselineTop
  TextBaselineHanging
  TextBaselineMiddle
  TextBaselineAlphabetic
  TextBaselineIdeographic
  TextBaselineBottom
}

pub type TextDirection {
  TextDirectionLtr
  TextDirectionRtl
  TextDirectionInherit
}

pub type Angle {
  Radians(Float)
}

pub type Vec2 =
  #(Float, Float)
