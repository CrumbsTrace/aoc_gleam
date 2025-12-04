import eset as set
import gleam/list
import gleam/pair
import gleam/string

pub fn run(lines: List(String)) -> #(Int, Int) {
  let rolls =
    lines
    |> list.index_map(fn(line, y) {
      list.index_map(string.to_graphemes(line), fn(c, x) { #(#(x, y), c) })
    })
    |> list.flatten()
    |> list.filter_map(fn(t) {
      case pair.second(t) == "@" {
        True -> Ok(pair.first(t))
        False -> Error(Nil)
      }
    })
    |> set.from_list()

  let p1_removed = remove_rolls(rolls, True)
  let new_rolls = set.difference(rolls, p1_removed)
  let p2 = remove_repeatedly(new_rolls)
  #(set.size(p1_removed), p2 + set.size(p1_removed))
}

fn remove_repeatedly(remaining_rolls: set.Set(#(Int, Int))) -> Int {
  let newly_removed = remove_rolls(remaining_rolls, False)
  let amount_removed = set.size(newly_removed)
  case amount_removed {
    0 -> 0
    _ -> {
      let new_rolls = set.difference(remaining_rolls, newly_removed)
      amount_removed + remove_repeatedly(new_rolls)
    }
  }
}

fn remove_rolls(
  remaining_rolls: set.Set(#(Int, Int)),
  p1: Bool,
) -> set.Set(#(Int, Int)) {
  let newly_removed =
    set.fold(
      fn(roll, acc) {
        let #(x, y) = roll
        let roll_count = count_rolls(x, y, remaining_rolls, acc, p1)
        case roll_count <= 4 {
          True -> set.add(#(x, y), acc)
          False -> acc
        }
      },
      set.new(),
      remaining_rolls,
    )
  newly_removed
}

fn count_rolls(
  x: Int,
  y: Int,
  remaining_rolls: set.Set(#(Int, Int)),
  newly_removed: set.Set(#(Int, Int)),
  p1: Bool,
) -> Int {
  list.fold(list.range(-1, 1), 0, fn(r_acc, dy) {
    list.fold(list.range(-1, 1), r_acc, fn(c_acc, dx) {
      // Quit early cause we're already over the limit
      case c_acc > 4 {
        True -> c_acc
        False -> {
          let nx = x + dx
          let ny = y + dy
          case
            set.contains(#(nx, ny), remaining_rolls)
            || { !p1 && set.contains(#(nx, ny), newly_removed) }
          {
            True -> c_acc + 1
            False -> c_acc
          }
        }
      }
    })
  })
}
