import paint as p
import paint/encode

fn round_trip(pic) {
  pic |> encode.to_string() |> encode.from_string
}

pub fn circle_round_trip_test() {
  let assert Ok(_) = round_trip(p.circle(5.0))
}

pub fn blank_round_trip_test() {
  let assert Ok(_) = round_trip(p.blank())
}

pub fn arc_round_trip_test() {
  let assert Ok(_) =
    round_trip(p.arc(30.0, p.angle_deg(20.0), p.angle_rad(1.0), p.Clockwise))
}

pub fn path_round_trip_test() {
  let assert Ok(_) =
    round_trip(
      p.path(#(1.0, 2.0), [
        p.path_line(#(3.0, 4.0)),
        p.path_arc_centre(
          #(5.0, 6.0),
          7.0,
          p.angle_deg(8.0),
          p.angle_deg(9.0),
          p.Counterclockwise,
        ),
        p.path_arc_corner(#(10.0, 11.0), #(12.0, 13.0), 14.0),
        p.path_bezier(#(15.0, 16.0), #(17.0, 18.0), #(19.0, 20.0)),
      ]),
    )
}

pub fn text_round_trip_test() {
  let assert Ok(_) = round_trip(p.text("Hello world", px: 15))
}

pub fn fill_round_trip_test() {
  let assert Ok(_) =
    round_trip(p.circle(20.0) |> p.fill(p.colour_rgb(100, 200, 100)))
}

pub fn stroke_round_trip_test() {
  let assert Ok(_) =
    round_trip(p.circle(20.0) |> p.stroke(p.colour_rgb(100, 200, 100), 3.0))
}

pub fn stroke_none_round_trip_test() {
  let assert Ok(_) = round_trip(p.circle(20.0) |> p.stroke_none())
}

pub fn translate_round_trip_test() {
  let assert Ok(_) = round_trip(p.circle(20.0) |> p.translate_xy(10.0, -30.0))
}

pub fn scale_round_trip_test() {
  let assert Ok(_) = round_trip(p.circle(20.0) |> p.scale_uniform(2.0))
}

pub fn rotate_round_trip_test() {
  let assert Ok(_) = round_trip(p.circle(20.0) |> p.rotate(p.angle_rad(2.0)))
}

pub fn combine_round_trip_test() {
  let assert Ok(_) = round_trip(p.circle(20.0) |> p.concat(p.square(20.0)))
}

pub fn image_scaling_pixelated_round_trip_test() {
  let assert Ok(_) = round_trip(p.blank() |> p.image_scaling_pixelated())
}

pub fn image_scaling_smooth_round_trip_test() {
  let assert Ok(_) = round_trip(p.blank() |> p.image_scaling_smooth())
}

pub fn text_align_round_trip_test() {
  let assert Ok(_) =
    round_trip(p.text("Hey", px: 20) |> p.text_align(p.TextAlignLeft))
}

pub fn text_baseline_round_trip_test() {
  let assert Ok(_) =
    round_trip(
      p.text("Hey", px: 20) |> p.text_baseline(p.TextBaselineAlphabetic),
    )
}

pub fn text_direction_round_trip_test() {
  let assert Ok(_) =
    round_trip(p.text("Hey", px: 20) |> p.text_direction(p.TextDirectionRtl))
}

pub fn font_family_round_trip_test() {
  let assert Ok(_) = round_trip(p.text("Hey", px: 20) |> p.font_family("Arial"))
}
// Note: there is no round trip test for images since I currently can't construct an image without the canvas back-end
