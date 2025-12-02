import gleam/int
import gleam/list
import gleam/result.{unwrap}
import gleam/string

pub fn run(input: String) -> #(Int, Int) {
  input
  |> string.split(",")
  |> list.fold(#(0, 0), fn(acc, range) {
    let #(p1, p2) = acc
    case string.split_once(range, "-") {
      Ok(#(l, r)) -> {
        let min = int.parse(l) |> unwrap(0)
        let max = int.parse(r) |> unwrap(0)
        let numbers = list.range(min, max)
        #(
          p1 + { list.filter(numbers, is_silly) |> int.sum() },
          p2 + { list.filter(numbers, is_super_silly) |> int.sum() },
        )
      }
      _ -> #(p1, p2)
    }
  })
}

fn is_silly(v: Int) -> Bool {
  let v_string = int.to_string(v)
  let half_length = string.length(v_string) / 2
  let l = string.slice(v_string, 0, half_length)
  let r = string.drop_start(v_string, half_length)
  l == r
}

fn is_super_silly(v: Int) -> Bool {
  case v {
    v if v < 10 -> False
    _ -> {
      let v = int.to_string(v) |> string.to_graphemes()
      let length = list.length(v)
      let half_length = list.length(v) / 2
      let chunk_sizes = list.range(1, half_length)

      chunk_sizes
      |> list.any(fn(chunk_size) {
        length % chunk_size == 0
        && {
          v
          |> list.sized_chunk(chunk_size)
          |> list.unique()
          |> list.length()
        }
        == 1
      })
    }
  }
}
