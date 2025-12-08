import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn take_ints(text: String, seperator s: String) {
  chunk_by_as(string.to_graphemes(text), by: fn(c) { c == s }, map: fn(v) {
    parse(string.concat(v))
  })
}

pub fn parse_ints(lines: List(String)) {
  list.map(lines, fn(v) { result.unwrap(int.parse(v), 0) })
}

pub fn split_whitespace(s: String) {
  split_whitespace_inner(string.to_graphemes(s))
}

fn split_whitespace_inner(chars: List(String)) {
  chunk_by_as(chars, by: fn(c) { c == " " }, map: string.concat)
}

pub fn parse(v: String) {
  result.unwrap(int.parse(v), 0)
}

pub fn chunk_by_as(l: List(a), by f: fn(a) -> Bool, map m: fn(List(a)) -> b) {
  let l = list.drop_while(l, f)
  case l {
    [] -> []
    _ -> {
      let #(v, ts) = list.split_while(l, fn(v) { !f(v) })
      [m(v), ..chunk_by_as(ts, f, m)]
    }
  }
}

pub fn chunk_by_map(l: List(a), by f: fn(a) -> Bool, map m: fn(a) -> b) {
  let l = list.drop_while(l, f)
  case l {
    [] -> []
    _ -> {
      let #(v, ts) = list.split_while(l, fn(v) { !f(v) })
      [list.map(v, m), ..chunk_by_map(ts, f, m)]
    }
  }
}

pub fn split_fold(t: String, sep: String, acc: a, f: fn(a, String) -> a) {
  chunk_fold(
    string.to_graphemes(t),
    by: fn(v) { v == sep },
    acc: acc,
    f: fn(a, v) { f(a, string.concat(v)) },
  )
}

pub fn chunk_fold(
  l: List(a),
  by pred: fn(a) -> Bool,
  acc acc: b,
  f f: fn(b, List(a)) -> b,
) -> b {
  let l = list.drop_while(l, pred)
  case l {
    [] -> acc
    _ -> {
      let #(v, ts) = list.split_while(l, fn(v) { !pred(v) })
      chunk_fold(ts, pred, f(acc, v), f)
    }
  }
}

pub fn find_index(l: List(a), pred: fn(a) -> Bool) {
  let index =
    list.fold_until(l, 0, fn(acc, v) {
      case pred(v) {
        True -> list.Stop(acc)
        False -> list.Continue(acc + 1)
      }
    })

  case list.length(l) == index {
    True -> -1
    False -> index
  }
}

pub fn find_indices(l: List(a), pred: fn(a) -> Bool) {
  list.index_fold(l, [], fn(acc, v, i) {
    case pred(v) {
      True -> [i, ..acc]
      False -> acc
    }
  })
}
