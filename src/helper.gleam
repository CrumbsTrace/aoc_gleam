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
      let value = string.join(value, "")
      [value, ..split_whitespace_inner(rest)]
    }
  }
}

pub fn zip4(w, x, y, z) {
  case w, x, y, z {
    [v1, ..t_w], [v2, ..t_x], [v3, ..t_y], [v4, ..t_z] -> {
      [#(v1, v2, v3, v4), ..zip4(t_w, t_x, t_y, t_z)]
    }
    _, _, _, _ -> []
  }
}

pub fn zip5(v, w, x, y, z) {
  case v, w, x, y, z {
    [v1, ..t_v], [v2, ..t_w], [v3, ..t_x], [v4, ..t_y], [v5, ..t_z] -> {
      [#(v1, v2, v3, v4, v5), ..zip5(t_v, t_w, t_x, t_y, t_z)]
    }
    _, _, _, _, _ -> []
  }
}

pub fn parse(v: String) {
  result.unwrap(int.parse(v), 0)
}
