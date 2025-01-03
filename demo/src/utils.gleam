import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html

// Example source code
import examples_code

// Convert a file path for an example into a heading
// "my_example.gleam" => "My example"
pub fn title_from_path(path: examples_code.Path) -> String {
  let assert Ok(name) = list.last(path)
  let assert Ok(#(name, _extension)) = string.split_once(name, on: ".")
  let name = string.replace(name, each: "_", with: " ")
  string.capitalise(name)
}

pub fn get_references_by_filename() -> Dict(String, examples_code.Reference) {
  dict.from_list(
    list.map(examples_code.references, fn(r) {
      let assert Ok(filename) = list.last(r.path)
      #(filename, r)
    }),
  )
}

pub fn highlight(code: String, lang: String) -> element.Element(a) {
  html.div([attribute.class("code-snippet")], [
    element.element(
      "highlighted-code",
      [attribute.attribute("code", code), attribute.attribute("lang", lang)],
      [],
    ),
  ])
}

pub fn code(content: String) -> element.Element(a) {
  html.code([], [element.text(content)])
}

pub fn italic(content: String) -> element.Element(a) {
  html.em([], [element.text(content)])
}

pub fn bold(content: String) -> element.Element(a) {
  html.strong([], [element.text(content)])
}
