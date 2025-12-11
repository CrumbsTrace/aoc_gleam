import gleam/dict
import gleam/list
import gleam/pair
import gleam/string

pub fn run(lines: List(String)) {
  let graph =
    list.fold(lines, dict.new(), fn(graph, line) {
      let device = string.slice(line, 0, 3)
      let connections =
        string.split(string.slice(line, 5, string.length(line) - 5), " ")
      dict.insert(graph, device, connections)
    })

  let p1 = pair.first(count("you", graph, dict.new(), True, True))
  let p2 = pair.first(count("svr", graph, dict.new(), False, False))
  #(p1, p2)
}

fn count(current, graph, cache, found_dac, found_fft) {
  case current {
    "out" if found_dac && found_fft -> #(1, cache)
    "out" -> #(0, cache)
    current -> {
      let found_dac = found_dac || current == "dac"
      let found_fft = found_fft || current == "fft"
      case dict.get(graph, current) {
        Ok(connections) -> {
          list.fold(connections, #(0, cache), fn(acc, connection) {
            let #(sum, cache) = acc
            let cache_key = #(connection, found_dac, found_fft)
            let #(count, new_cache) = case dict.get(cache, cache_key) {
              Ok(v) -> #(v, cache)
              _ -> {
                let #(count, cache) =
                  count(connection, graph, cache, found_dac, found_fft)
                let cache = dict.insert(cache, cache_key, count)
                #(count, cache)
              }
            }
            #(sum + count, new_cache)
          })
        }
        _ -> #(0, cache)
      }
    }
  }
}
