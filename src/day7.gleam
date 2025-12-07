import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, Some}
import gleam/result.{unwrap}
import gleam/string
import helper

pub fn run(lines: List(String)) {
  let start =
    unwrap(list.first(lines), "")
    |> string.to_graphemes()
    |> helper.find_index(fn(v) { v == "S" })

  let beams = dict.new()
  let beams = dict.insert(beams, start, 1)
  let width = string.length(unwrap(list.first(lines), ""))
  shoot_beams(lines, 0, beams, width)
}

fn shoot_beams(
  lines: List(String),
  count: Int,
  beams: dict.Dict(Int, Int),
  width: Int,
) {
  case lines {
    [line, ..ts] -> {
      let splitters =
        helper.find_indices(string.to_graphemes(line), fn(v) { v == "^" })
      let hit = list.filter(splitters, fn(x) { dict.has_key(beams, x) })
      let count = count + list.length(hit)
      let beams =
        list.fold(hit, beams, fn(beams, x) {
          let c = unwrap(dict.get(beams, x), 0)
          let beams = dict.delete(beams, x)
          let beams = case x > 0 {
            True -> dict.upsert(beams, x - 1, fn(v) { update(v, c) })
            False -> beams
          }
          let beams = case x < width {
            True -> dict.upsert(beams, x + 1, fn(v) { update(v, c) })
            False -> beams
          }
          beams
        })
      shoot_beams(ts, count, beams, width)
    }
    _ -> #(count, dict.values(beams) |> int.sum())
  }
}

fn update(v: Option(Int), c: Int) {
  case v {
    Some(v) -> v + c
    _ -> c
  }
}
