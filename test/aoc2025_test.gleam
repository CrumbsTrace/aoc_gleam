import day1
import day2
import day3
import day4
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

pub fn day2_test() {
  let input = get_contents("inputs/day2.txt")
  let result = day2.run(input)
  should.equal(result, #(22_062_284_697, 46_666_175_279))
}

pub fn day3_test() {
  let input = get_lines("inputs/day3.txt")
  let result = day3.run(input)
  should.equal(result, #(17_330, 171_518_260_283_767))
}

pub fn day4_test() {
  let input = get_lines("inputs/day4.txt")
  let result = day4.run(input)
  should.equal(result, #(1395, 8451))
}

fn get_contents(file) {
  simplifile.read(file)
  |> unwrap("")
  |> string.trim()
}

fn get_lines(file) {
  get_contents(file)
  |> string.split("\n")
}
