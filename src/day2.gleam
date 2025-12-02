import eset as set
import gleam/int
import gleam/list
import gleam/result.{unwrap}
import gleam/string

pub fn run(input: String) -> #(Int, Int) {
  let silly_numbers = generate_silly_numbers()
  input
  |> string.split(",")
  |> list.fold(#(0, 0), fn(acc, range) {
    let #(p1, p2) = acc
    case string.split_once(range, "-") {
      Ok(#(l, r)) -> {
        let min = int.parse(l) |> unwrap(0)
        let max = int.parse(r) |> unwrap(0)
        let p2_nums = lazy_range_filter(min, max, silly_numbers)
        let p1_nums = list.filter(p2_nums, is_silly)
        #(p1 + { p1_nums |> int.sum() }, p2 + { p2_nums |> int.sum() })
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

fn generate_silly_numbers() -> set.Set(Int) {
  list.flat_map(list.range(1, 99_999), fn(v) {
    let v = int.to_string(v)
    case string.length(v) {
      5 -> [unwrap(int.parse(v <> v), 0)]
      4 -> [unwrap(int.parse(v <> v), 0)]
      l ->
        list.range(2, 10 / l)
        |> list.map(fn(c) { string.repeat(v, c) |> int.parse() |> unwrap(0) })
    }
  })
  |> set.from_list()
}

fn lazy_range_filter(c: Int, end: Int, silly_numbers: set.Set(Int)) {
  case c > end {
    True -> []
    False ->
      case set.contains(c, silly_numbers) {
        True -> [c, ..lazy_range_filter(c + 1, end, silly_numbers)]
        False -> lazy_range_filter(c + 1, end, silly_numbers)
      }
  }
}
