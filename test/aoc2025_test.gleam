import day1
import gleam/result.{unwrap}
import gleam/string
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day1_test() {
  let input = get_lines("inputs/day1.txt")
  let result = day1.run(input)
  should.equal(result, #(1135, 6558))
}

fn get_lines(file) {
  simplifile.read(file)
  |> unwrap("")
  |> string.trim()
  |> string.split("\n")
}
