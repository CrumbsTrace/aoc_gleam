import gleam/int
import gleam/list
import gleam/result.{unwrap}
import gleam/string.{concat, trim}
import helper.{parse, split_whitespace}

pub fn run(lines: List(String)) -> #(Int, Int) {
  let ops = unwrap(list.last(lines), "") |> split_whitespace()
  let number_lines = list.take(lines, list.length(lines) - 1)
  let p1_numbers =
    number_lines
    |> list.map(fn(v) { split_whitespace(v) |> list.map(parse) })
    |> list.transpose()

  let p2_numbers =
    number_lines
    |> list.map(string.to_graphemes)
    |> list.transpose()
    |> helper.chunk_by_map(
      by: fn(v) { list.all(v, fn(c) { c == " " }) },
      map: fn(v) { parse(trim(concat(v))) },
    )

  let p1 = solve(p1_numbers, ops)
  let p2 = solve(p2_numbers, ops)
  #(p1, p2)
}

fn solve(values, ops) {
  case values, ops {
    [v, ..v_t], [op, ..ops_t] ->
      case op {
        "*" -> int.product(v) + solve(v_t, ops_t)
        "+" -> int.sum(v) + solve(v_t, ops_t)
        _ -> 0
      }
    _, _ -> 0
  }
}
