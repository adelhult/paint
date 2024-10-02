import examples/arc
import examples/blank
import examples/circle
import examples/combine
import examples/community_colour
import examples/concat
import examples/fill
import examples/lines
import examples/polygon
import examples/readme
import examples/rectangle
import examples/rotate
import examples/scale
import examples/square
import examples/stroke
import examples/text
import examples/translate
import examples_code
import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string
import lustre
import lustre/attribute.{class}
import lustre/element.{type Element, keyed, text}
import lustre/element/html.{button, div, h1, h2, hr, p, pre}
import lustre/event.{on_click}
import paint
import paint/canvas

// Convert a file path for an example into a heading
// "my_example.gleam" => "My example"
fn title_from_path(path: examples_code.Path) -> String {
  let assert Ok(name) = list.last(path)
  let assert Ok(#(name, _extension)) = string.split_once(name, on: ".")
  let name = string.replace(name, each: "_", with: " ")
  string.capitalise(name)
}

fn get_references_by_filename() -> Dict(String, examples_code.Reference) {
  dict.from_list(
    list.map(examples_code.references, fn(r) {
      let assert Ok(filename) = list.last(r.path)
      #(filename, r)
    }),
  )
}

const canvas_width = 125

const canvas_height = 125

fn paint_canvas(
  picture: paint.Picture,
  attr: List(attribute.Attribute(a)),
) -> element.Element(a) {
  element.element(
    "paint-canvas",
    [
      attribute.height(canvas_width),
      attribute.width(canvas_height),
      attribute.property("picture", picture),
      attribute.style([
        #("background", "#f5f5f5"),
        #("border-radius", "10px"),
        #("line-height", "0"),
      ]),
      ..attr
    ],
    [],
  )
}

fn highlight(code code: String) -> element.Element(a) {
  element.element("highlighted-code", [attribute.attribute("code", code)], [])
}

pub fn main() {
  canvas.define_web_component()
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Example {
  Example(
    title: String,
    description: String,
    source_code: String,
    picture: paint.Picture,
  )
}

type Model {
  Model(examples: List(Example), show_source_code: Bool)
}

type Msg {
  ToggleSourceCode
}

fn init(_flags) {
  let refs = get_references_by_filename()
  let ref_to_example = fn(
    refs: Dict(String, examples_code.Reference),
    filename: String,
    picture: paint.Picture,
  ) {
    let assert Ok(r) = dict.get(refs, filename)
    Example(
      title: title_from_path(r.path),
      description: r.module_doc,
      source_code: r.content,
      picture: picture
        |> paint.translate_xy(
          int.to_float(canvas_width) /. 2.0,
          int.to_float(canvas_height) /. 2.0,
        ),
    )
  }

  Model(show_source_code: True, examples: [
    ref_to_example(refs, "blank.gleam", blank.blank_example()),
    ref_to_example(refs, "circle.gleam", circle.circle_example()),
    ref_to_example(refs, "arc.gleam", arc.arc_example()),
    ref_to_example(refs, "polygon.gleam", polygon.polygon_example()),
    ref_to_example(refs, "lines.gleam", lines.lines_example()),
    ref_to_example(refs, "rectangle.gleam", rectangle.rectangle_example()),
    ref_to_example(refs, "square.gleam", square.square_example()),
    ref_to_example(refs, "text.gleam", text.text_example()),
    ref_to_example(refs, "fill.gleam", fill.fill_example()),
    ref_to_example(refs, "stroke.gleam", stroke.stroke_example()),
    ref_to_example(refs, "translate.gleam", translate.translate_example()),
    ref_to_example(refs, "scale.gleam", scale.scale_example()),
    ref_to_example(refs, "rotate.gleam", rotate.rotate_example()),
    ref_to_example(refs, "combine.gleam", combine.combine_example()),
    ref_to_example(refs, "concat.gleam", concat.concat_example()),
    ref_to_example(
      refs,
      "community_colour.gleam",
      community_colour.community_colour_example(),
    ),
    ref_to_example(refs, "readme.gleam", readme.readme_example()),
  ])
}

fn view_example(example: Example, show_source show_source: Bool) -> Element(Msg) {
  let Example(title, description, source_code, picture) = example

  div([class("example")], [
    h2([], [text(title)]),
    div([class("text")], [
      p([], [text(description)]),
      case show_source {
        True -> highlight(code: source_code)
        False -> element.none()
      },
    ]),
    div([class("canvas")], [paint_canvas(picture, [])]),
  ])
}

fn update(model: Model, msg: Msg) {
  case msg {
    ToggleSourceCode ->
      Model(..model, show_source_code: bool.negate(model.show_source_code))
  }
}

fn view(model: Model) {
  html.main([], [
    h1([], [text("Gleam Paint Examples")]),
    p([], [text("Make drawings, animations, and games with Gleam")]),
    button([event.on_click(ToggleSourceCode)], [
      text(case model.show_source_code {
        True -> "Hide source code"
        False -> "Show source code"
      }),
    ]),
    hr([]),
    keyed(
      div([class("example-list")], _),
      list.map(model.examples, fn(example) {
        #(
          example.title,
          view_example(example, show_source: model.show_source_code),
        )
      }),
    ),
  ])
}
