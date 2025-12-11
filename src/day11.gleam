import gleam/dict
import gleam/list
import gleam/string

pub fn run(lines: List(String)) {
  let graph =
    list.fold(lines, dict.new(), fn(acc, line) {
      let device = string.slice(line, 0, 3)
      let connections =
        string.split(string.slice(line, 5, string.length(line) - 5), " ")
      dict.insert(acc, device, connections)
    })

  let p1_paths = get_paths("you", [], graph)
  let p2_paths =
    get_paths("svr", [], graph)
    |> echo
    |> list.filter(fn(path) {
      list.contains(path, "dac") && list.contains(path, "fft")
    })
  #(list.length(p1_paths), list.length(p2_paths))
}

fn get_paths(current, path, graph) {
  case current {
    "out" -> [list.reverse(["out", ..path])]
    current -> {
      case dict.get(graph, current) {
        Ok(connections) -> {
          list.flat_map(connections, fn(connection) {
            get_paths(connection, [current, ..path], graph)
          })
        }
        _ -> []
      }
    }
  }
}
