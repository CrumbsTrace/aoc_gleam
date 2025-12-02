import argv
import day1
import day2
import gleam/float
import gleam/int
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  use day <- result.try(get_day_arg())
  use contents <- result.try(get_file_contents(day))
  run(day, contents)
  Ok("Success")
}

fn run(day: String, contents: String) {
  let lines = string.split(contents, "\n")
  case day {
    "1" -> {
      echo day1.run(lines)
      Nil
    }
    "2" -> {
      echo day2.run(contents)
      Nil
    }
    _ -> Nil
  }
}

fn get_file_contents(day: String) {
  let file_name = "inputs/day" <> day <> ".txt"
  case simplifile.read(from: file_name) {
    Ok(contents) -> Ok(string.trim(contents))
    Error(error) ->
      Error(
        "Could not find file at '"
        <> file_name
        <> "' "
        <> simplifile.describe_error(error),
      )
  }
}

fn get_day_arg() {
  case argv.load().arguments {
    [day] -> Ok(day)
    _ -> Error("Please pass in the day you wish to run")
  }
}

@external(erlang, "erlang", "monotonic_time")
fn erlang_monotonic_time(unit: Int) -> Int

pub fn time(f: fn() -> a) -> #(a, Float) {
  let start = erlang_monotonic_time(1_000_000)
  let result = f()
  repeat(99, fn() {
    f()
    Nil
  })
  let stop = erlang_monotonic_time(1_000_000)

  #(
    result,
    float.to_precision({ int.to_float(stop - start) /. 1000.0 } /. 100.0, 3),
  )
}

fn repeat(n: Int, f: fn() -> Nil) -> Nil {
  case n {
    0 -> Nil
    _ -> {
      f()
      repeat(n - 1, f)
    }
  }
}
