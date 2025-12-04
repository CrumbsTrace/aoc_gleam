import eset as set
import gleam/list
import gleam/string
import iv

pub fn run(lines: List(String)) -> #(Int, Int) {
  let grid =
    lines
    |> list.map(fn(line) { string.to_graphemes(line) |> iv.from_list() })
    |> iv.from_list()

  let p1_removed = remove_rolls(grid, set.new())
  let p2_removed = remove_repeatedly(grid, p1_removed)
  #(set.size(p1_removed), set.size(p2_removed))
}

fn remove_repeatedly(
  grid: iv.Array(iv.Array(String)),
  removed: set.Set(#(Int, Int)),
) {
  let new = remove_rolls(grid, removed)
  case set.size(new) {
    0 -> removed
    _ -> remove_repeatedly(grid, set.union(removed, new))
  }
}

fn remove_rolls(
  grid: iv.Array(iv.Array(String)),
  removed: set.Set(#(Int, Int)),
) -> set.Set(#(Int, Int)) {
  let height = iv.length(grid)
  iv.index_fold(grid, set.new(), fn(acc, row, y) {
    iv.index_fold(row, acc, fn(acc, c, x) {
      case c {
        "." -> acc
        _ -> {
          case set.contains(#(x, y), removed) {
            True -> acc
            False -> {
              let roll_count = count_rolls(x, y, height, grid, removed)
              case roll_count <= 4 {
                True -> set.add(#(x, y), acc)
                False -> acc
              }
            }
          }
        }
      }
    })
  })
}

fn count_rolls(
  x: Int,
  y: Int,
  height: Int,
  grid: iv.Array(iv.Array(String)),
  removed: set.Set(#(Int, Int)),
) -> Int {
  list.fold(list.range(-1, 1), 0, fn(r_acc, dy) {
    list.fold(list.range(-1, 1), r_acc, fn(c_acc, dx) {
      let nx = x + dx
      let ny = y + dy
      case ny {
        -1 -> c_acc
        _ if ny >= height -> c_acc
        _ -> {
          let row = iv.get_or_default(grid, ny, iv.new())
          case set.contains(#(nx, ny), removed) {
            True -> c_acc
            False -> {
              case iv.get_or_default(row, nx, ".") {
                "@" -> c_acc + 1
                _ -> c_acc
              }
            }
          }
        }
      }
    })
  })
}
