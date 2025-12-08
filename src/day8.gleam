import eset as set
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/pair
import helper

pub fn run(lines: List(String)) {
  let circuit_count = list.length(lines)
  let pairs =
    list.map(lines, fn(line) {
      case helper.take_ints(line, ",") {
        [x, y, z] -> #(x, y, z)
        _ -> panic
      }
    })
    |> list.combination_pairs()
    |> list.map(fn(v) {
      let #(#(x1, y1, z1), #(x2, y2, z2)) = v
      let x_dist = x2 - x1
      let y_dist = y2 - y1
      let z_dist = z2 - z1
      #(v, x_dist * x_dist + y_dist * y_dist + z_dist * z_dist)
    })
    |> list.sort(fn(l, r) { int.compare(pair.second(l), pair.second(r)) })

  let p1 =
    pairs
    |> list.take(1000)
    |> connect(circuit_count)
    |> list.map(fn(v) { pair.second(v) |> set.size() })
    |> list.sort(fn(l, r) { int.compare(r, l) })
    |> list.take(3)
    |> int.product()

  let p2 = case pairs |> connect(circuit_count) {
    [#(_, last_pair)] -> {
      case last_pair |> set.to_list() {
        [#(x1, _, _), #(x2, _, _)] -> x1 * x2
        _ -> panic
      }
    }
    _ -> panic
  }
  #(p1, p2)
}

fn connect(connections, circuit_count) {
  list.fold_until(connections, [], fn(groups, connection) {
    let #(c1, c2) = pair.first(connection)
    let c1_find_result =
      list.find(groups, fn(v) { set.contains(c1, pair.second(v)) })
    let c2_find_result =
      list.find(groups, fn(v) { set.contains(c2, pair.second(v)) })

    let new_groups = case c1_find_result {
      Error(_) -> {
        case c2_find_result {
          Error(_) -> [#(c1, set.from_list([c1, c2])), ..groups]
          Ok(#(c2_key, c2_key_set)) ->
            list.key_set(groups, c2_key, set.add(c1, c2_key_set))
        }
      }
      Ok(#(c1_key, c1_key_set)) -> {
        case c2_find_result {
          Error(_) -> list.key_set(groups, c1_key, set.add(c2, c1_key_set))
          Ok(#(c2_key, c2_key_set)) -> {
            case c2_key == c1_key {
              True -> groups
              False -> {
                let groups =
                  list.key_set(
                    groups,
                    c1_key,
                    set.union(c1_key_set, c2_key_set),
                  )
                case list.key_pop(groups, c2_key) {
                  Ok(#(_, v)) -> v
                  Error(_) -> panic
                }
              }
            }
          }
        }
      }
    }
    case new_groups {
      [l] -> {
        case set.size(pair.second(l)) == circuit_count {
          True -> Stop([#(c1, set.from_list([c1, c2]))])
          False -> Continue(new_groups)
        }
      }
      _ -> Continue(new_groups)
    }
  })
}
