import gleam/int
import gleam/list
import gleam/order
import gleam/result.{unwrap}
import gleam/string

pub fn run(lines: List(String)) -> #(Int, Int) {
  lines
  |> list.fold(#(0, 0), fn(acc, line) {
    let #(p1, p2) = acc
    let length = string.length(line)
    let chars = string.to_graphemes(line)
    let r1 = string.concat(raid_bank(chars, 2, length))
    let r2 = string.concat(raid_bank(chars, 12, length))
    #(p1 + unwrap(int.parse(r1), 0), p2 + unwrap(int.parse(r2), 0))
  })
}

fn raid_bank(chars, count, length) {
  case count {
    0 -> []
    _ -> {
      let #(max, i) = next(chars, length - { count - 1 })
      let to_drop = i + 1
      [max, ..raid_bank(list.drop(chars, to_drop), count - 1, length - to_drop)]
    }
  }
}

fn next(chars, end) {
  next_inner(list.drop(chars, 1), 1, end, unwrap(list.first(chars), "X"), 0)
}

fn next_inner(chars, i, end, max, max_i) {
  case chars {
    _ if end == i -> #(max, max_i)
    [a, ..] ->
      case string.compare(a, max) == order.Gt {
        True -> next_inner(list.drop(chars, 1), i + 1, end, a, i)
        False -> next_inner(list.drop(chars, 1), i + 1, end, max, max_i)
      }
    _ -> #(max, max_i)
  }
}
