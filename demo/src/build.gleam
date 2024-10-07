import demo
import gleam/io
import lustre/ssg

pub fn main() {
  let build =
    ssg.new("./priv")
    |> ssg.add_static_dir("./static")
    |> ssg.add_static_route("/", demo.view())
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      io.debug(e)
      io.println("Build failed!")
    }
  }
}
