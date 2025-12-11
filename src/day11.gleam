import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string

pub fn run(lines: List(String)) {
  let #(graph, reverse) =
    list.fold(lines, #(dict.new(), dict.new()), fn(acc, line) {
      let #(graph, reverse) = acc
      let device = string.slice(line, 0, 3)
      let connections =
        string.split(string.slice(line, 5, string.length(line) - 5), " ")
      let graph = dict.insert(graph, device, connections)

      let reverse =
        list.fold(connections, reverse, fn(reverse, connection) {
          dict.upsert(reverse, connection, fn(entry) {
            case entry {
              Some(v) -> [device, ..v]
              _ -> [device]
            }
          })
        })

      #(graph, reverse)
    })

  // let p1_paths = get_paths("you", [], graph)
  // let p2_paths =
  //   get_paths("svr", [], graph)
  //   |> echo
  //   |> list.filter(fn(path) {
  //     list.contains(path, "dac") && list.contains(path, "fft")
  //   })
  // #(list.length(p1_paths), list.length(p2_paths))
  //
  let p1 = get_counts("you", graph, True, True)
  let p2 = echo get_counts("svr", graph, False, False)
  // let p1 = count_paths("out", "you", p1_counts, reverse)
  // let p2 = count_paths("out", "svr", p2_counts, reverse)
  #(p1, p2)
}

fn get_counts(current, graph, found_dac, found_fft) {
  case current {
    "out" if found_dac && found_fft -> 1
    "out" -> 0
    current -> {
      let found_dac = found_dac || current == "dac"
      let found_fft = found_fft || current == "fft"
      case dict.get(graph, current) {
        Ok(connections) -> {
          list.fold(connections, 0, fn(acc, connection) {
            acc + get_counts(connection, graph, found_dac, found_fft)
          })
        }
        _ -> 0
      }
    }
  }
}
