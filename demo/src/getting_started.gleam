import gleam/dict
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html.{div, p}
import utils

fn guide(title: String, content: Element(a)) -> Element(a) {
  html.details([], [html.summary([], [text(title)]), content])
}

pub fn canvas_guide() -> Element(a) {
  // TODO: we should avoid doing this needless work every 
  // redraw (if we have any reactivity inside this function in the future)
  let references = utils.get_references_by_filename()
  let assert Ok(basic_gleam) = dict.get(references, "tutorial_basic.gleam")
  let assert Ok(basic_html) = dict.get(references, "tutorial_webpage.html")
  div([], [
    guide(
      "Project using a HTML canvas",
      html.ol([], [
        html.li([], [
          text(
            "Create a project with the javascript target, like this for instance:",
          ),
          utils.highlight("gleam new myapp --template javascript", "shell"),
        ]),
        html.li([], [
          text("Add Paint as a dependency"),
          utils.highlight("cd myapp\ngleam add paint", "shell"),
        ]),
        html.li([], [
          text(
            "Create a Picture in your main function and call the canvas.display function.",
          ),
          utils.highlight(basic_gleam.content, "gleam"),
        ]),
        html.li([], [
          text("Build the project"),
          utils.highlight("gleam build", "shell"),
        ]),
        html.li([], [
          text("Create an HTML file with a canvas element"),
          utils.highlight(basic_html.content, "html"),
        ]),
        html.li([], [
          text(
            "And you are done! Start file server and take a look at you HTML file. For instance:",
          ),
          utils.highlight("python3 -m http.server 3000", "python"),
        ]),
      ]),
    ),
    guide(
      "Using Lustre (or other web frameworks)",
      div([], [
        p([], [
          text(
            "Paint offers a web components API that can be used together with web frameworks such as Lustre. You can read more about this ",
          ),
          html.a(
            [
              attribute.href(
                "https://hexdocs.pm/paint/paint/canvas.html#define_web_component",
              ),
            ],
            [text("in the documentation")],
          ),
        ]),
      ]),
    ),
    guide(
      "Interactive apps and games",
      div([], [
        p([], [
          text(
            "If you wish to create animations, interactive apps or games you should try using ",
          ),
          html.a(
            [
              attribute.href(
                "https://hexdocs.pm/paint/paint/canvas.html#interact",
              ),
            ],
            [text("Paint’s interactive API.")],
          ),
          text(
            " You can follow the first guide using a HTML canvas to get started.",
          ),
        ]),
        p([], [
          text(
            "Note: a limitation of the interactive API at the moment is that it does not include a system for managing arbitrary side effects (playing sounds, fetching data etc.). If you need this, you may wish to use Paint together with ",
          ),
          html.a([attribute.href("https://hexdocs.pm/lustre/")], [
            text("Lustre"),
          ]),
          text(" to manage state and effects instead."),
        ]),
      ]),
    ),
  ])
}

pub fn intro_text() -> Element(a) {
  div([], [
    p([], [
      text("Paint is a "),
      utils.italic("domain-specific language"),
      text(
        " that allows you to create pictures and tiny interactive experiences with Gleam in a ",
      ),
      utils.italic("declarative"),
      text(" fashion."),
    ]),
    p([], [
      text("Everything in Paint revolves around the "),
      html.a([attribute.href("https://hexdocs.pm/paint/paint.html#Picture")], [
        utils.code("Picture"),
      ]),
      text(" type, pictures are made by combining multiple functions like "),
      utils.code("circle"),
      text(", "),
      utils.code("rotate"),
      text(" and "),
      utils.code("fill"),
      text(
        ". You can learn more about this in the examples section further down this page. ",
      ),
      text("But first, follow one of these short setup guide to get started:"),
    ]),
  ])
}
