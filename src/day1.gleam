import gleam/int
import gleam/list
import gleam/result.{unwrap}

pub fn run(lines: List(String)) -> #(Int, Int) {
  let #(_, p1, p2) =
    list.fold(lines, #(50, 0, 0), fn(acc, line) {
      let #(current, p1, p2) = acc
      let new_value = case line {
        "L" <> clicks -> current - unwrap(int.parse(clicks), 0)
        "R" <> clicks -> current + unwrap(int.parse(clicks), 0)
        _ -> 0
      }
      let rotations = int.absolute_value(new_value) / 100
      let rotations = case new_value <= 0 && current != 0 {
        True -> rotations + 1
        False -> rotations
      }
      let new_value = int.modulo(new_value, 100) |> unwrap(0)
      case new_value {
        0 -> #(new_value, p1 + 1, p2 + rotations)
        _ -> #(new_value, p1, p2 + rotations)
      }
    })

  #(p1, p2)
}
