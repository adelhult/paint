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
import gleam/io
import gleam/list
import gleam/string
import lustre
import lustre/attribute.{class}
import lustre/element.{type Element, keyed, text}
import lustre/element/html.{button, div, h1, h2, hr, p, pre}
import lustre/event.{on_click}
import paint

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

type Example {
  Example(
    title: String,
    description: String,
    source_code: String,
    picture: paint.Picture,
  )
}

pub fn view() {
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

  let examples = [
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
  ]
  html.html([], [
    default_head(),
    html.body([], [
      html.main([], [
        h1([], [text("Gleam Paint Examples")]),
        p([], [text("Make drawings, animations, and games with Gleam")]),
        hr([]),
        keyed(
          div([class("example-list")], _),
          list.map(examples, fn(example) {
            #(example.title, view_example(example))
          }),
        ),
      ]),
    ]),
  ])
}

fn default_head() {
  html.head([], [
    html.meta([attribute.attribute("charset", "UTF-8")]),
    html.meta([
      attribute.name("viewport"),
      attribute.attribute("content", "width=device-width, initial-scale=1.0"),
    ]),
    google_fonts(
      "https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100..800;1,100..800&family=Lexend:wght@100..900&display=swap",
    ),
    js_module("./highlight.js"),
    css_stylesheet("./style.css"),
    setup_paint(),
  ])
}

// Rather hacky, this can be a lot cleaner
// if you are making a SPA with ordinary Lustre
// and not using the SSG.
fn setup_paint() -> Element(a) {
  html.script([attribute.src("./setup_paint.js"), attribute.type_("module")], "")
}

fn google_fonts(href: String) -> Element(a) {
  element.fragment([
    html.link([
      attribute.rel("preconnect"),
      attribute.href("https://fonts.googleapis.com"),
    ]),
    html.link([
      attribute.rel("preconnect"),
      attribute.href("https://fonts.gstatic.com"),
      attribute.attribute("crossorigin", "crossorigin"),
    ]),
    html.link([attribute.rel("stylesheet"), attribute.href(href)]),
  ])
}

fn js_module(src: String) -> Element(a) {
  html.script([attribute.src(src), attribute.type_("module")], "")
}

fn css_stylesheet(href: String) -> Element(a) {
  html.link([attribute.rel("stylesheet"), attribute.href(href)])
}

fn view_example(example: Example) -> Element(Nil) {
  let Example(title, description, source_code, picture) = example
  div([], [
    div([class("example")], [
      h2([], [text(title)]),
      div([class("text")], [
        p([], [text(description)]),
        highlight(code: source_code),
      ]),
      div([class("canvas")], [paint_canvas(picture, [])]),
    ]),
  ])
}
