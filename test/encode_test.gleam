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

pub fn polygon_round_trip_test() {
  let assert Ok(_) = round_trip(p.polygon([#(0.0, 0.0), #(10.0, 20.0)]))
}

pub fn polygon_empty_round_trip_test() {
  let assert Ok(_) = round_trip(p.polygon([]))
}

pub fn arc_round_trip_test() {
  let assert Ok(_) =
    round_trip(p.arc(30.0, p.angle_deg(20.0), p.angle_rad(1.0)))
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
