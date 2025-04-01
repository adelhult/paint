//// A simple noughts and crosses demo
//// to test the [paint library](https://hexdocs.pm/paint/)

import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/yielder.{type Yielder, Next}
import gleam_community/colour
import paint as p
import paint/canvas
import paint/event
import prng/random

// --- Data types ---

type Tile {
  Nought
  Cross
}

/// A *valid* position on the game board
type Pos {
  Pos(Int, Int)
}

type State {
  Playing(PlayingState)
  GameOver(
    // None is used to represent ties
    winner: Option(Tile),
  )
}

type PlayingState {
  PlayingState(
    selected_pos: Option(Pos),
    board: Dict(Pos, Tile),
    random_positions: Yielder(Pos),
  )
}

// --- Constants ---

const tile_size_px = 70.0

const board_size = 3

/// Center the board
/// Update if other constants are changed:
/// (300 - tile_size_px * board_size) / 2
const offset_px = 45.0

// --- API to access the game board ---

fn board_insert(state: PlayingState, pos: Pos, tile: Tile) -> PlayingState {
  PlayingState(..state, board: dict.insert(state.board, pos, tile))
}

fn board_get(state: PlayingState, pos: Pos) -> Option(Tile) {
  option.from_result(dict.get(state.board, pos))
}

fn board_number_placed(state: PlayingState) -> Int {
  dict.size(state.board)
}

fn all_positions() -> List(Pos) {
  list.range(from: 0, to: board_size - 1)
  |> list.flat_map(fn(x) {
    list.range(from: 0, to: board_size - 1)
    |> list.map(fn(y) { Pos(x, y) })
  })
}

/// Map a pixel coordinate to a (valid) tile position
fn pixels_to_pos(x: Float, y: Float) -> Option(Pos) {
  let pos_x = float.floor({ x -. offset_px } /. tile_size_px) |> float.round
  let pos_y = float.floor({ y -. offset_px } /. tile_size_px) |> float.round

  // Ensure that the position is actually within the board
  case pos_x < board_size && pos_x >= 0 && pos_y < board_size && pos_y >= 0 {
    True -> Some(Pos(pos_x, pos_y))
    False -> None
  }
}

// --- Entry point to the program ---
pub fn main() {
  canvas.interact(init, update, view, "#mycanvas")
}

fn init(_config: canvas.Config) -> State {
  new_game()
}

fn new_game() -> State {
  // We supply a stream of random positions for the
  // computer player to pick from when making a move
  let generator = {
    let int_gen = random.int(0, board_size - 1)
    random.pair(int_gen, int_gen)
    |> random.map(fn(pair) { Pos(pair.0, pair.1) })
  }

  Playing(PlayingState(
    selected_pos: None,
    random_positions: random.to_random_yielder(generator),
    board: dict.new(),
  ))
}

// --- Here comes the actual rendering code, using the main Paint API ---

fn view(state: State) -> p.Picture {
  case state {
    GameOver(winning_tile) -> view_winner_screen(winning_tile)
    Playing(state) -> view_board(state)
  }
  |> p.translate_xy(offset_px, offset_px)
}

fn view_winner_screen(winner: Option(Tile)) -> p.Picture {
  p.text(
    case winner {
      None -> "You tied!"
      Some(Cross) -> "You won!"
      Some(Nought) -> "You lost!"
    },
    px: 20,
  )
  |> p.concat(
    p.text("Press to play again", px: 15)
    |> p.fill(colour.dark_gray)
    |> p.translate_y(25.0),
  )
  |> p.translate_y(50.0)
}

fn view_board(state: PlayingState) -> p.Picture {
  let is_active = fn(my_pos) {
    option.map(state.selected_pos, fn(active_pos) { active_pos == my_pos })
    |> option.unwrap(or: False)
  }

  p.combine(
    list.map(all_positions(), fn(pos) {
      let tile = board_get(state, pos)
      let Pos(x, y) = pos
      let tile_colour = case is_active(pos) {
        True -> colour.dark_grey
        False -> colour.grey
      }

      p.square(tile_size_px)
      |> p.fill(tile_colour)
      |> p.concat(view_tile(tile))
      // Shift the position
      |> p.translate_xy(
        int.to_float(x) *. tile_size_px,
        int.to_float(y) *. tile_size_px,
      )
    }),
  )
}

fn view_tile(tile: Option(Tile)) -> p.Picture {
  let thick_stroke = p.stroke(_, colour.black, 5.0)
  let padding = 15.0
  let size = tile_size_px -. padding
  case tile {
    Some(Cross) ->
      p.combine([
        p.lines([#(0.0, 0.0), #(size, size)]),
        p.lines([#(size, 0.0), #(0.0, size)]),
      ])
      |> p.translate_xy(padding /. 2.0, padding /. 2.0)
      |> thick_stroke()
    Some(Nought) ->
      p.circle(size /. 2.0)
      // Center in top left corner
      |> p.translate_xy(tile_size_px /. 2.0, tile_size_px /. 2.0)
      |> thick_stroke()
    None -> p.blank()
  }
}

// --- Game play logic ---

fn update(state: State, event: event.Event) -> State {
  case state, event {
    Playing(playing_state), event.MouseMoved(x, y) ->
      Playing(PlayingState(..playing_state, selected_pos: pixels_to_pos(x, y)))

    Playing(playing_state), event.MousePressed(event.MouseButtonLeft) -> {
      case playing_state.selected_pos {
        Some(pos) -> move(playing_state, pos)
        None -> state
      }
    }

    GameOver(..), event.MousePressed(..) -> {
      new_game()
    }

    // We don't care about any other events
    Playing(..), _ -> state
    GameOver(..), _ -> state
  }
}

fn move(state: PlayingState, pos: Pos) -> State {
  let selected_tile = board_get(state, pos)
  case selected_tile {
    // If the tile is free
    None -> {
      // The human is playing crosses
      let state =
        Playing(board_insert(state, pos, Cross))
        // Check if the human just won
        |> check(pos)

      // Give the computer a chance to respond
      let #(state, computer_pos) = computer_response(state)
      // ...and if the game is not already over, and it actually made a move
      // check that move too
      case computer_pos {
        Some(computer_pos) -> check(state, computer_pos)
        None -> state
      }
    }

    // Do nothing if the spot is already taken
    _ -> Playing(state)
  }
}

/// Check if someone has won the game or if the entire board is filled
fn check(state: State, just_played: Pos) -> State {
  case state {
    GameOver(..) -> state
    Playing(playing_state) -> {
      let Pos(just_played_x, just_played_y) = just_played
      let assert Some(just_played_tile) = board_get(playing_state, just_played)

      let matching = fn(pos) {
        board_get(playing_state, pos)
        |> option.map(fn(pos_tile) { pos_tile == just_played_tile })
        |> option.unwrap(or: False)
      }

      let range = list.range(0, board_size - 1)

      let current_row = fn() {
        range
        |> list.map(Pos(_, just_played_y))
        |> list.all(matching)
      }

      let current_col = fn() {
        range
        |> list.map(Pos(just_played_x, _))
        |> list.all(matching)
      }

      let diagonal = fn() {
        just_played_x == just_played_y
        && range
        |> list.map(fn(x) { Pos(x, x) })
        |> list.all(matching)
      }

      let anti_diagonal = fn() {
        just_played_x + just_played_y == board_size - 1
        && range
        |> list.map(fn(i) { Pos(i, board_size - 1 - i) })
        |> list.all(matching)
      }

      case current_row() || current_col() || diagonal() || anti_diagonal() {
        True -> GameOver(Some(just_played_tile))
        False ->
          case board_number_placed(playing_state) == board_size * board_size {
            True -> GameOver(None)
            False -> Playing(playing_state)
          }
      }
    }
  }
}

/// The computer just picks a random free tile
fn computer_response(state: State) -> #(State, Option(Pos)) {
  case state {
    GameOver(..) -> #(state, None)
    Playing(state) -> {
      let assert Next(pos, random_positions) =
        yielder.step(state.random_positions)

      let state = PlayingState(..state, random_positions:)
      let tile = board_get(state, pos)

      case tile {
        None -> #(
          Playing(
            PlayingState(..state, board: dict.insert(state.board, pos, Nought)),
          ),
          Some(pos),
        )
        // Try again with another tile if it was occupied
        _ -> computer_response(Playing(state))
      }
    }
  }
}
