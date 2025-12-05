import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import gleam/result.{unwrap}
import gleam/string

pub fn run(lines: List(String)) {
  let #(ranges, ids) = list.split_while(lines, fn(v) { v != "" })
  let ranges =
    list.map(ranges, fn(range) {
      case string.split_once(range, "-") {
        Ok(#(l, r)) -> #(unwrap(int.parse(l), 0), unwrap(int.parse(r), 0))
        Error(_) -> #(0, 0)
      }
    })

  let ids = list.drop(ids, 1) |> list.map(fn(v) { unwrap(int.parse(v), 0) })

  let ranges =
    list.sort(ranges, fn(x, y) {
      let order_l = int.compare(pair.first(x), pair.first(y))
      case order_l {
        order.Eq -> int.compare(pair.second(x), pair.second(y))
        _ -> order_l
      }
    })
    |> merge()

  let p1 =
    list.count(ids, fn(id) {
      list.any(ranges, fn(range) {
        let #(l, r) = range
        id >= l && id <= r
      })
    })

  let p2 =
    list.fold(ranges, 0, fn(acc, range) {
      let #(l, r) = range
      acc + { r - l + 1 }
    })

  #(p1, p2)
}

pub fn merge(ranges) {
  merge_inner(ranges, -1, -1)
}

fn merge_inner(ranges, start, last_r) {
  let tail = list.drop(ranges, 1)
  case list.first(ranges) {
    Ok(#(l, r)) -> {
      case l - 1 <= last_r {
        // Merge
        True -> merge_inner(tail, start, int.max(r, last_r))
        False ->
          case last_r != -1 {
            True -> [#(start, last_r), ..merge_inner(tail, l, r)]
            False -> merge_inner(tail, l, r)
          }
      }
    }
    Error(_) -> [#(start, last_r)]
  }
}
