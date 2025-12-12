import gleam/dict
import gleam/int
import gleam/list
import gleam/result.{unwrap}
import gleam/string
import helper

pub fn run(lines: List(String)) {
  let shapes =
    list.take(lines, 29)
    |> list.chunk(fn(v) { v == "" })
    |> list.map(fn(area) { list.drop(area, 1) })
    |> list.filter(fn(area) { area != [] })
    |> list.index_fold(dict.new(), fn(acc, area, index) {
      dict.insert(acc, index, area)
    })

  let shape_sizes =
    dict.fold(shapes, dict.new(), fn(acc, index, shape) {
      dict.insert(
        acc,
        index,
        int.sum(
          list.map(shape, fn(line) {
            list.count(string.to_graphemes(line), fn(c) { c == "#" })
          }),
        ),
      )
    })

  list.drop(lines, 30)
  |> list.count(fn(region) {
    let #(sizes, presents) = unwrap(string.split_once(region, ": "), #("", ""))
    let #(w, h) = case helper.take_ints(sizes, "x") {
      [w, h] -> {
        #(w, h)
      }
      _ -> panic
    }

    let presents = helper.take_ints(presents, " ")
    let #(min, max) =
      list.index_fold(presents, #(0, 0), fn(acc, times, index) {
        let #(min, max) = acc
        #(
          min + times * unwrap(dict.get(shape_sizes, index), 0),
          max + times * 9,
        )
      })

    let region_size = w * h

    case region_size >= max {
      True -> True
      False ->
        case region_size < min {
          True -> False
          False -> panic
        }
    }
  })
}
