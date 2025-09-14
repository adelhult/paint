import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import lustre
import lustre/attribute.{class}
import lustre/element.{type Element, keyed, text}
import lustre/element/html.{button, div, h1, h2, h3, hr, p}
import lustre/event
import paint
import paint/canvas
import paint/encode

// Example pictures
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
import getting_started
import utils

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
      attribute.attribute("picture", encode.to_string(picture)),
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

type Category {
  Category(name: String, examples: List(Example))
}

type Model {
  Model(examples: List(Category), show_source_code: Bool)
}

type Msg {
  ToggleSourceCode
}

fn init(_flags) {
  let refs = utils.get_references_by_filename()
  let ref_to_example = fn(
    refs: Dict(String, examples_code.Reference),
    filename: String,
    picture: paint.Picture,
  ) {
    let assert Ok(r) = dict.get(refs, filename)
    Example(
      title: utils.title_from_path(r.path),
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
    Category("Shapes", [
      ref_to_example(refs, "blank.gleam", blank.blank_example()),
      ref_to_example(refs, "circle.gleam", circle.circle_example()),
      ref_to_example(refs, "arc.gleam", arc.arc_example()),
      ref_to_example(refs, "polygon.gleam", polygon.polygon_example()),
      ref_to_example(refs, "lines.gleam", lines.lines_example()),
      ref_to_example(refs, "rectangle.gleam", rectangle.rectangle_example()),
      ref_to_example(refs, "square.gleam", square.square_example()),
      ref_to_example(refs, "text.gleam", text.text_example()),
    ]),
    Category("Style", [
      ref_to_example(refs, "fill.gleam", fill.fill_example()),
      ref_to_example(refs, "stroke.gleam", stroke.stroke_example()),
      ref_to_example(
        refs,
        "community_colour.gleam",
        community_colour.community_colour_example(),
      ),
    ]),
    Category("Transform", [
      ref_to_example(refs, "translate.gleam", translate.translate_example()),
      ref_to_example(refs, "scale.gleam", scale.scale_example()),
      ref_to_example(refs, "rotate.gleam", rotate.rotate_example()),
    ]),
    Category("Combine", [
      ref_to_example(refs, "combine.gleam", combine.combine_example()),
      ref_to_example(refs, "concat.gleam", concat.concat_example()),
    ]),
    Category("Other", [
      ref_to_example(refs, "readme.gleam", readme.readme_example()),
    ]),
  ])
}

fn update(model: Model, msg: Msg) {
  case msg {
    ToggleSourceCode ->
      Model(..model, show_source_code: bool.negate(model.show_source_code))
  }
}

fn view_category(category: Category, show_source: Bool) {
  let class_name = case show_source {
    True -> "example-list"
    False -> "example-list-compact"
  }

  div([], [
    anchor(category.name),
    h2([], [text(category.name)]),
    hr([]),
    keyed(
      div([class(class_name)], _),
      list.map(category.examples, fn(example) {
        #(example.title, view_example(example, show_source))
      }),
    ),
  ])
}

fn view_example(example: Example, show_source show_source: Bool) -> Element(a) {
  let Example(title, description, source_code, picture) = example

  case show_source {
    True ->
      div([class("example")], [
        h3([], [text(title)]),
        div([class("text")], [
          p([], [text(description)]),
          utils.highlight(source_code, "gleam"),
        ]),
        div([class("canvas")], [paint_canvas(picture, [])]),
      ])
    False ->
      div([class("example-compact")], [
        h3([], [text(title)]),
        div([class("canvas")], [paint_canvas(picture, [])]),
      ])
  }
}

fn view(model: Model) {
  div([], [
    div([class("logo-background")], [
      logo(),
      text("Make drawings, animations, and games with Gleam"),
    ]),
    html.main([], [
      links(),
      getting_started_section(),
      examples(model),
      interactive_demo(),
    ]),
  ])
}

fn getting_started_section() -> Element(a) {
  div([], [
    anchor("getting-started"),
    h1([], [text("Getting Started")]),
    getting_started.intro_text(),
    getting_started.canvas_guide(),
  ])
}

fn examples(model: Model) -> Element(Msg) {
  div([], [
    anchor("examples"),
    h1([], [text("Examples")]),
    category_toc(model),
    button([event.on_click(ToggleSourceCode)], [
      text(case model.show_source_code {
        True -> "Compact view"
        False -> "Detailed view"
      }),
    ]),
    keyed(
      div([class("example-section")], _),
      list.map(model.examples, fn(category) {
        #(category.name, view_category(category, model.show_source_code))
      }),
    ),
  ])
}

fn category_toc(model: Model) -> Element(Msg) {
  div([], [
    h3([], [text("Contents")]),
    keyed(
      html.ul([class("toc")], _),
      list.map(model.examples, fn(category) {
        #(
          category.name,
          html.a([attribute.href("#" <> category.name)], [
            html.li([], [text(category.name)]),
          ]),
        )
      }),
    ),
  ])
}

fn interactive_demo() -> Element(a) {
  div([], [
    anchor("interactive-demo"),
    h1([], [text("Interactive demo")]),
    div([class("interactive-demo")], [
      h3([], [text("Noughts and crosses")]),
      html.a(
        [
          attribute.href(
            "https://github.com/adelhult/paint/tree/main/demos/noughts_and_crosses",
          ),
        ],
        [text("Source code")],
      ),
      html.iframe([
        attribute.width(300),
        attribute.height(300),
        attribute.attribute("scrolling", "no"),
        attribute.src("https://adelhult.github.io/paint/noughts_and_crosses/"),
      ]),
    ]),
  ])
}

fn logo() -> Element(a) {
  html.img([class("logo"), attribute.src("./priv/static/logo.svg")])
}

fn anchor(name: String) -> Element(a) {
  html.a([attribute.id(name), class("anchor")], [])
}

fn links() -> Element(a) {
  let links_list = [
    #(text("Getting started"), "#getting-started"),
    #(text("Examples"), "#examples"),
    #(text("Interactive demo"), "#interactive-demo"),
    #(text("GitHub"), "https://github.com/adelhult/paint"),
    #(
      html.span([], [
        text("Documentation"),
        html.img([attribute.src("https://img.shields.io/badge/hex-docs-ffaff3")]),
      ]),
      "https://hexdocs.pm/paint/",
    ),
  ]

  div([class("menu-container")], [
    keyed(
      html.menu([], _),
      list.map(links_list, fn(link) {
        let #(name, address) = link
        #(address, html.a([attribute.href(address)], [html.li([], [name])]))
      }),
    ),
  ])
}
