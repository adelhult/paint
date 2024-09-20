import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam_community/colour
import paint as p
import paint/canvas
import paint/event

pub fn blank_example() -> p.Picture {
  p.blank()
}

pub fn circle_example() -> p.Picture {
  p.circle(40.0)
}

pub fn arc_example() -> p.Picture {
  let radius = 40.0
  p.arc(radius, p.angle_deg(0.0), p.angle_deg(100.0))
}

pub fn polygon_example() -> p.Picture {
  p.polygon([#(-10.0, -20.0), #(50.0, 30.0), #(-20.0, 50.0)])
}

pub fn lines_example() -> p.Picture {
  p.lines([#(-10.0, -20.0), #(50.0, 30.0), #(-20.0, 50.0)])
}

pub fn rectangle_example() -> p.Picture {
  p.rectangle(50.0, 80.0)
}

pub fn square_example() -> p.Picture {
  p.square(80.0)
}

pub fn text_example() -> p.Picture {
  p.text("Hi!", 40)
}

pub fn fill_example() -> p.Picture {
  circle_example() |> p.fill(blue()) |> p.stroke_none()
}

pub fn stroke_example() -> p.Picture {
  circle_example() |> p.stroke(blue(), width: 5.0)
}

fn blue() {
  p.colour_rgb(64, 110, 142)
}

pub fn translate_example() -> p.Picture {
  circle_example() |> p.translate_y(25.0) |> p.concat(circle_example())
}

pub fn scale_example() -> p.Picture {
  circle_example()
  |> p.scale_uniform(0.5)
  |> p.concat(circle_example())
}

pub fn rotate_example() -> p.Picture {
  // A bit more of an advanced example, just for fun!
  p.combine(
    list.repeat(rectangle_example(), times: 6)
    |> list.index_map(fn(picture, i) {
      p.rotate(picture, p.angle_deg(360.0 /. 6.0 *. int.to_float(i)))
    }),
  )
}

pub fn combine_example() -> p.Picture {
  p.combine([
    circle_example(),
    circle_example() |> p.translate_x(50.0),
    circle_example() |> p.translate_x(100.0),
  ])
}

pub fn concat_example() -> p.Picture {
  circle_example()
  |> p.concat(circle_example() |> p.translate_x(50.0))
}

pub fn readme_example() -> p.Picture {
  p.combine([
    p.circle(50.0),
    p.circle(30.0) |> p.fill(p.colour_rgb(0, 200, 200)),
    p.rectangle(100.0, 50.0) |> p.rotate(p.angle_deg(30.0)),
    p.text("Hello world", 20) |> p.translate_y(-65.0),
  ])
}

pub fn community_colour_example() -> p.Picture {
  // paint uses `gleam_community/colour` which means that you are free
  // to import and use any of the many functions and predefined colours from that package.
  let assert Ok(cs) =
    ["#2f2f2f", "#584355", "#a6f0fc", "#ffaff3"]
    |> list.map(colour.from_rgb_hex_string)
    |> result.all()
  p.combine(
    list.index_map(cs, fn(c, i) {
      p.circle(30.0) |> p.fill(c) |> p.translate_x(int.to_float(i) *. 30.0)
    }),
  )
  // center
  |> p.translate_x(-45.0)
}

// Web component example.
// Used together with `define_web_component`.
// NOTE: this is nothing special with this picture.
// The interesting things happen inside of `index.html`.
pub fn web_component_example() -> p.Picture {
  p.text("<paint-canvas>", 10)
  |> p.translate_xy(20.0, 40.0)
}

// An example of the interactive API
// used together with the function
// `canvas.interact(init, update, view, canvas_id)`
// ------------------------

/// The state of the game
pub type State {
  State(
    x: Float,
    y: Float,
    dy: Float,
    direction: Direction,
    time: Float,
    mouse_x: Float,
    mouse_y: Float,
    width: Float,
    height: Float,
  )
}

/// Movement direction of the "Player"
pub type Direction {
  Left
  Right
}

const ground_height = 20.0

const player_length = 40.0

/// The "init" function is used to setup the initial
/// state of the game
pub fn init(config: canvas.Config) -> State {
  State(
    x: 10.0,
    y: config.height -. ground_height -. player_length,
    dy: 0.0,
    direction: Right,
    time: 0.0,
    width: config.width,
    height: config.height,
    mouse_x: 0.0,
    mouse_y: 0.0,
  )
}

/// A pure function that takes the state of the game
/// and creates an image to present to the canvas
pub fn view(state: State) -> p.Picture {
  let ground =
    p.rectangle(state.width, ground_height)
    |> p.fill(p.colour_rgb(0, 0, 0))
    |> p.translate_y(state.height -. ground_height)

  let pos_text =
    "(" <> float.to_string(state.x) <> ", " <> float.to_string(state.y) <> ")"

  let player =
    p.combine([
      p.square(player_length),
      p.text(pos_text, 10) |> p.translate_y(-5.0),
    ])
    |> p.translate_xy(state.x, state.y)

  let mouse = p.circle(10.0) |> p.translate_xy(state.mouse_x, state.mouse_y)

  p.combine([
    mouse,
    player,
    ground,
    p.text("Press <space> to jump", 10) |> p.translate_xy(5.0, 15.0),
    p.text(float.to_string(state.time) <> " ms", 10)
      |> p.translate_xy(5.0, 30.0),
  ])
}

/// "update" should be a pure function that given
/// some state and and an event produces a new state
pub fn update(state: State, event: event.Event) -> State {
  let speed = 1.0
  let gravity_acceleration = 0.5
  let ground_level = state.height -. ground_height

  case event {
    event.Tick(time) ->
      State(
        ..state,
        time: time,
        // Flip the direction of movement if we hit the edges
        // of the screen
        direction: case state.x +. player_length >. state.width {
          // flip direction
          True -> Left
          False ->
            case state.x <. 0.0 {
              // flip direction
              True -> Right
              False -> state.direction
            }
        },
        // Move the player left/right every tick
        x: case state.direction {
          Right -> state.x +. speed
          Left -> state.x -. speed
        },
        y: float.min(state.y +. state.dy, ground_level -. player_length),
        dy: case state.y +. player_length <. ground_level {
          // Apply gravity if we are in the air
          True -> state.dy +. gravity_acceleration
          // if we are on the ground, remove the downwards velocity
          False -> float.min(state.dy, 0.0)
        },
      )
    event.KeyboardPressed(key) ->
      case key {
        // Move the player into the air if we press space
        event.KeySpace -> State(..state, dy: -7.0)
        _ -> state
      }
    event.MouseMoved(x, y) -> {
      State(..state, mouse_x: x, mouse_y: y)
    }
    event.MousePressed(button) -> {
      io.println("Button '" <> string.inspect(button) <> "' was pressed!")
      state
    }
    event.MouseReleased(button) -> {
      io.println("Button '" <> string.inspect(button) <> "' was released!")
      state
    }
    // all other events: do nothing
    _ -> state
  }
}
