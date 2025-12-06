import eset as set
import gleam/int
import gleam/list
import gleam/string
import helper.{parse}

pub fn run(input: String) -> #(Int, Int) {
  let silly_numbers = generate_silly_numbers()
  helper.split_fold(input, ",", #(0, 0), fn(acc, range) {
    let #(p1, p2) = acc
    case string.split_once(range, "-") {
      Ok(#(l, r)) -> {
        let p2_nums = range_filter(parse(l), parse(r), silly_numbers)
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
      5 -> [parse(v <> v)]
      4 -> [parse(v <> v)]
      3 -> [parse(v <> v), parse(v <> v <> v)]
      l -> range_map(2, 10 / l, v)
    }
  })
  |> set.from_list()
}

fn range_filter(c: Int, end: Int, silly_numbers: set.Set(Int)) {
  case c > end {
    True -> []
    False ->
      case set.contains(c, silly_numbers) {
        True -> [c, ..range_filter(c + 1, end, silly_numbers)]
        False -> range_filter(c + 1, end, silly_numbers)
      }
  }
}

fn range_map(c: Int, end: Int, v: String) {
  case c == end {
    True -> [parse(string.repeat(v, c))]
    False -> [parse(string.repeat(v, c)), ..range_map(c + 1, end, v)]
  }
}
