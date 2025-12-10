import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import gleamy/priority_queue as pq
import helper

pub fn run(lines: List(String)) {
  list.fold(lines, 0, fn(acc, line) {
    let sections =
      line
      |> string.split(" ")
      |> list.map(fn(s) { string.slice(s, 1, string.length(s) - 2) })

    case sections {
      [lights, ..rest] -> {
        let length = list.length(rest)
        let rest = list.map(rest, fn(l) { helper.take_ints(l, ",") })
        let #(buttons, _) = list.split(rest, length - 1)

        //To binary for easier logic
        let lights = lights_to_binary(lights)
        let buttons_binary = list.map(buttons, button_to_binary)
        acc + bfs(lights, buttons_binary)
      }
      _ -> panic
    }
  })
}

fn lights_to_binary(lights) {
  let lights = string.to_graphemes(lights)
  list.index_fold(lights, 0, fn(acc, light, index) {
    case light == "#" {
      True -> {
        int.bitwise_or(acc, helper.int_power(2, index))
      }
      False -> acc
    }
  })
}

fn button_to_binary(button) {
  list.fold(button, 0, fn(acc, light) {
    int.bitwise_or(acc, helper.int_power(2, light))
  })
}

fn bfs(target, buttons) {
  let pq =
    pq.from_list([#(0, 0)], fn(a, b) {
      let #(_, pressed_a) = a
      let #(_, pressed_b) = b
      int.compare(pressed_a, pressed_b)
    })
  let lowest_costs = dict.new() |> dict.insert(0, 0)
  bfs_1(pq, target, buttons, lowest_costs)
}

fn bfs_1(pqueue, target, buttons, lowest_costs) {
  case pq.pop(pqueue) {
    Ok(#(#(current, cost), queue)) -> {
      let new_states =
        buttons
        |> list.map(fn(button) { int.bitwise_exclusive_or(current, button) })
        |> list.filter(fn(light) {
          case dict.get(lowest_costs, light) {
            Ok(v) if v <= cost + 1 -> False
            _ -> True
          }
        })

      case list.any(new_states, fn(state) { state == target }) {
        True -> cost + 1
        False -> {
          let lowest_costs =
            list.fold(new_states, lowest_costs, fn(acc, v) {
              dict.insert(acc, v, cost + 1)
            })
          let queue =
            list.fold(new_states, queue, fn(acc, state) {
              pq.push(acc, #(state, cost + 1))
            })
          bfs_1(queue, target, buttons, lowest_costs)
        }
      }
    }
    _ -> panic
  }
}
