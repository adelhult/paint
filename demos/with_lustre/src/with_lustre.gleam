import gleam/int
import gleam/list
import gleam_community/colour
import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import paint as p
import paint/canvas
import paint/encode

pub fn main() {
  canvas.define_web_component()
  let app = lustre.simple(init, update, view)

  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn init(_flags) {
  0
}

type Msg {
  Incr
  Decr
}

fn update(model, msg) {
  case msg {
    Incr -> model + 1
    Decr -> model - 1
  }
}

const size = 350

pub fn picture(n: Int) -> p.Picture {
  list.repeat(p.circle, n)
  |> list.index_map(fn(pic, i) {
    let hue = int.to_float(i * 10 % 360) /. 360.0
    let assert Ok(col) = colour.from_hsla(h: hue, s: 1.0, l: 0.7, a: 0.2)
    pic(15.5 +. 1.0 *. int.to_float(i))
    |> p.translate_y(75.0)
    |> p.rotate(p.angle_deg(10.0 *. int.to_float(i)))
    |> p.fill(col)
  })
  |> p.combine
  |> p.translate_xy(int.to_float(size) /. 2.0, int.to_float(size) /. 2.0)
  |> p.concat(p.text(int.to_string(n), px: 40) |> p.translate_xy(25.0, 50.0))
}

fn canvas(picture: p.Picture, attributes: List(attribute.Attribute(a))) {
  element.element(
    "paint-canvas",
    [attribute.attribute("picture", encode.to_string(picture)), ..attributes],
    [],
  )
}

fn view(model) {
  html.div([], [
    canvas(picture(model), [
      attribute.height(size),
      attribute.width(size),
      attribute.style("background", "#f5f5f5"),
      attribute.style("line-height", "0"),
    ]),
    html.div([], [
      html.button([event.on_click(Incr)], [html.text("Add +")]),
      html.button([event.on_click(Decr)], [html.text("Remove -")]),
    ]),
  ])
}
