import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn take_ints(text: String) {
  text
  |> split_whitespace()
  |> parse_ints()
}

pub fn parse_ints(lines: List(String)) {
  list.map(lines, fn(v) { result.unwrap(int.parse(v), 0) })
}

pub fn split_whitespace(s: String) {
  split_whitespace_inner(string.to_graphemes(s))
}

fn split_whitespace_inner(chars: List(String)) {
  let chars = list.drop_while(chars, fn(c) { c == " " })
  case chars {
    [] -> []
    _ -> {
      let #(value, rest) = list.split_while(chars, fn(c) { c != " " })
      let value = string.concat(value)
      [value, ..split_whitespace_inner(rest)]
    }
  }
}

pub fn parse(v: String) {
  result.unwrap(int.parse(v), 0)
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
