import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam_community/colour
import paint.{type Picture}
import paint/internal/types.{
  type Angle, type FontProperties, type StrokeProperties, FontProperties,
  NoStroke, Radians, SolidStroke,
}

/// Serialize a `Picture` to a string.
/// 
/// If you wish to store the serialized data, remember that the library currently makes no stability guarantee that
/// the data can be deserialized by *future* versions of the library
pub fn to_string(picture: Picture) -> String {
  let version = "paint:unstable"
  json.object([
    #("version", json.string(version)),
    #("picture", picture_to_json(picture)),
  ])
  |> json.to_string
}

/// Attempt to deserialize a `Picture`
pub fn from_string(string: String) {
  let decoder = {
    use picture <- decode.field("picture", decode_picture())
    decode.success(picture)
  }
  json.parse(string, decoder)
}

fn decode_angle() {
  use radians <- decode.field("radians", decode.float)
  decode.success(Radians(radians))
}

fn decode_picture() -> Decoder(Picture) {
  use <- decode.recursive
  use ty <- decode.field("type", decode.string)

  case ty {
    "arc" -> {
      use radius <- decode.field("radius", decode.float)
      use start <- decode.field("start", decode_angle())
      use end <- decode.field("end", decode_angle())
      decode.success(types.Arc(radius, start:, end:))
    }
    "blank" -> decode.success(types.Blank)
    "combine" -> {
      use pictures <- decode.field(
        "pictures",
        decode.list(of: decode_picture()),
      )
      decode.success(types.Combine(pictures))
    }
    "fill" -> {
      use picture <- decode.field("picture", decode_picture())
      use colour <- decode.field("colour", colour.decoder())
      decode.success(types.Fill(picture, colour))
    }
    "polygon" -> {
      use points <- decode.field("points", decode.list(of: decode_vec2()))
      use closed <- decode.field("closed", decode.bool)
      decode.success(types.Polygon(points, closed))
    }
    "rotate" -> {
      use angle <- decode.field("angle", decode_angle())
      use picture <- decode.field("picture", decode_picture())
      decode.success(types.Rotate(picture, angle))
    }
    "scale" -> {
      use x <- decode.field("x", decode.float)
      use y <- decode.field("y", decode.float)
      use picture <- decode.field("picture", decode_picture())
      decode.success(types.Scale(picture, #(x, y)))
    }
    "stroke" -> {
      use stroke <- decode.field("stroke", decode_stroke())
      use picture <- decode.field("picture", decode_picture())
      decode.success(types.Stroke(picture, stroke))
    }
    "text" -> {
      use text <- decode.field("text", decode.string)
      use style <- decode.field("style", decode_font())
      decode.success(types.Text(text, style))
    }
    "translate" -> {
      use x <- decode.field("x", decode.float)
      use y <- decode.field("y", decode.float)
      use picture <- decode.field("picture", decode_picture())
      decode.success(types.Translate(picture, #(x, y)))
    }
    _ -> decode.failure(types.Blank, "Picture")
  }
}

fn decode_font() -> Decoder(FontProperties) {
  use size_px <- decode.field("sizePx", decode.int)
  use font_family <- decode.field("fontFamily", decode.string)
  decode.success(FontProperties(size_px:, font_family:))
}

fn decode_stroke() -> Decoder(StrokeProperties) {
  use stroke_type <- decode.field("type", decode.string)
  case stroke_type {
    "noStroke" -> decode.success(NoStroke)
    "solidStroke" -> {
      use colour <- decode.field("colour", colour.decoder())
      use thickness <- decode.field("thickness", decode.float)
      decode.success(SolidStroke(colour, thickness))
    }
    _ -> decode.failure(NoStroke, "StrokeProperties")
  }
}

fn decode_vec2() -> Decoder(#(Float, Float)) {
  use x <- decode.field("x", decode.float)
  use y <- decode.field("y", decode.float)
  decode.success(#(x, y))
}

fn picture_to_json(picture: Picture) -> Json {
  case picture {
    types.Arc(radius:, start:, end:) ->
      json.object([
        #("type", json.string("arc")),
        #("radius", json.float(radius)),
        #("start", angle_to_json(start)),
        #("end", angle_to_json(end)),
      ])
    types.Blank -> json.object([#("type", json.string("blank"))])
    types.Combine(from) ->
      json.object([
        #("type", json.string("combine")),
        #("pictures", json.array(from:, of: picture_to_json)),
      ])
    types.Fill(picture, colour) ->
      json.object([
        #("type", json.string("fill")),
        #("colour", colour.encode(colour)),
        #("picture", picture_to_json(picture)),
      ])
    types.Polygon(points, closed:) ->
      json.object([
        #("type", json.string("polygon")),
        #(
          "points",
          json.array(from: points, of: fn(point) {
            let #(x, y) = point
            json.object([#("x", json.float(x)), #("y", json.float(y))])
          }),
        ),
        #("closed", json.bool(closed)),
      ])
    types.Rotate(picture, angle) ->
      json.object([
        #("type", json.string("rotate")),
        #("angle", angle_to_json(angle)),
        #("picture", picture_to_json(picture)),
      ])
    types.Scale(picture, #(x, y)) ->
      json.object([
        #("type", json.string("scale")),
        #("x", json.float(x)),
        #("y", json.float(y)),
        #("picture", picture_to_json(picture)),
      ])
    types.Stroke(picture, stroke) ->
      json.object([
        #("type", json.string("stroke")),
        #("stroke", stroke_to_json(stroke)),
        #("picture", picture_to_json(picture)),
      ])
    types.Text(text:, style:) ->
      json.object([
        #("type", json.string("text")),
        #("text", json.string(text)),
        #("style", font_to_json(style)),
      ])
    types.Translate(picture, #(x, y)) ->
      json.object([
        #("type", json.string("translate")),
        #("x", json.float(x)),
        #("y", json.float(y)),
        #("picture", picture_to_json(picture)),
      ])
  }
}

fn font_to_json(font: FontProperties) -> Json {
  let FontProperties(size_px:, font_family:) = font
  json.object([
    #("sizePx", json.int(size_px)),
    #("fontFamily", json.string(font_family)),
  ])
}

fn stroke_to_json(stroke: StrokeProperties) -> Json {
  case stroke {
    NoStroke -> json.object([#("type", json.string("noStroke"))])
    SolidStroke(colour, thickness) ->
      json.object([
        #("type", json.string("solidStroke")),
        #("colour", colour.encode(colour)),
        #("thickness", json.float(thickness)),
      ])
  }
}

fn angle_to_json(angle: Angle) -> Json {
  let Radians(rad) = angle
  json.object([#("radians", json.float(rad))])
}
