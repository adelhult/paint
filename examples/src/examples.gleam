import gleam/float
import gleam/int
import gleam/list
import paint.{
  type CanvasConfig, type Event, type Picture, CanvasConfig, KeyUp, NoStroke,
  SolidStroke, Space, Tick, angle_deg, arc, blank, circle, color_rgb, combine,
  concat, fill, lines, polygon, rectangle, rotate, scale_uniform, square, stroke,
  text, translate_x, translate_xy, translate_y,
}

pub fn blank_example() -> Picture {
  blank()
}

pub fn circle_example() -> Picture {
  circle(40.0)
}

pub fn arc_example() -> Picture {
  let radius = 40.0
  arc(radius, angle_deg(0.0), angle_deg(100.0))
}

pub fn polygon_example() -> Picture {
  polygon([#(-10.0, -20.0), #(50.0, 30.0), #(-20.0, 50.0)])
}

pub fn lines_example() -> Picture {
  lines([#(-10.0, -20.0), #(50.0, 30.0), #(-20.0, 50.0)])
}

pub fn rectangle_example() -> Picture {
  rectangle(50.0, 80.0)
}

pub fn square_example() -> Picture {
  square(80.0)
}

pub fn text_example() -> Picture {
  text("Hi!", 40)
}

pub fn fill_example() -> Picture {
  circle_example() |> fill(blue()) |> stroke(NoStroke)
}

pub fn stroke_example() -> Picture {
  circle_example() |> stroke(SolidStroke(blue(), 5.0))
}

fn blue() {
  color_rgb(64, 110, 142)
}

pub fn translate_example() -> Picture {
  circle_example() |> translate_y(25.0) |> concat(circle_example())
}

pub fn scale_example() -> Picture {
  circle_example()
  |> scale_uniform(0.5)
  |> concat(circle_example())
}

pub fn rotate_example() -> Picture {
  // A bit more of an advanced example, just for fun!
  combine(
    list.repeat(rectangle_example(), times: 6)
    |> list.index_map(fn(picture, i) {
      rotate(picture, angle_deg(360.0 /. 6.0 *. int.to_float(i)))
    }),
  )
}

pub fn combine_example() -> Picture {
  combine([
    circle_example(),
    circle_example() |> translate_x(50.0),
    circle_example() |> translate_x(100.0),
  ])
}

pub fn concat_example() -> Picture {
  circle_example()
  |> concat(circle_example() |> translate_x(50.0))
}

pub fn readme_example() -> Picture {
  paint.combine([
    paint.circle(50.0),
    paint.circle(30.0) |> paint.fill(paint.color_rgb(0, 200, 200)),
    paint.rectangle(100.0, 50.0) |> paint.rotate(angle_deg(30.0)),
    paint.text("Hello world", 20) |> paint.translate_y(-65.0),
  ])
}

// An example of the interactive API
// used together with the function
// `interact_on_canvas(init, update, view, canvas_id)`
// ------------------------

/// The state of the game
pub type State {
  State(
    x: Float,
    y: Float,
    dy: Float,
    direction: Direction,
    time: Float,
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
pub fn init(config: CanvasConfig) -> State {
  State(
    x: 10.0,
    y: config.height -. ground_height -. player_length,
    dy: 0.0,
    direction: Right,
    time: 0.0,
    width: config.width,
    height: config.height,
  )
}

/// A pure function that takes the state of the game
/// and creates an image to present to the canvas
pub fn view(state: State) -> Picture {
  let ground =
    rectangle(state.width, ground_height)
    |> fill(color_rgb(0, 0, 0))
    |> translate_y(state.height -. ground_height)

  let pos_text =
    "(" <> float.to_string(state.x) <> ", " <> float.to_string(state.y) <> ")"

  let player =
    combine([square(player_length), text(pos_text, 10) |> translate_y(-5.0)])
    |> translate_xy(state.x, state.y)

  combine([
    player,
    ground,
    text("Press <space> to jump", 10) |> translate_xy(5.0, 15.0),
    text(float.to_string(state.time) <> " ms", 10) |> translate_xy(5.0, 30.0),
  ])
}

/// "update" should be a pure function that given
/// some state and and an event produces a new state
pub fn update(state: State, event: Event) -> State {
  let speed = 1.0
  let gravity_acceleration = 0.5
  let ground_level = state.height -. ground_height

  case event {
    Tick(time) ->
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
    KeyUp(key) ->
      case key {
        // Move the player into the air if we press space (when on ground level)
        Space -> State(..state, dy: -7.0)
        _ -> state
      }

    // all other events: do nothing
    _ -> state
  }
}
