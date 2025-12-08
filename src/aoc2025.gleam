import argv
import day1
import day2
import day3
import day4
import day5
import day6
import day7
import day8
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
      echo bench(fn() { day1.run(lines) })
      // echo day1.run(lines)
      Nil
    }
    "2" -> {
      // echo day2.run(contents)
      echo bench(fn() { day2.run(contents) })
      Nil
    }
    "3" -> {
      // echo day3.run(lines)
      echo bench(fn() { day3.run(lines) })
      Nil
    }
    "4" -> {
      // echo day4.run(lines)
      echo bench(fn() { day4.run(lines) })
      Nil
    }
    "5" -> {
      // echo day5.run(lines)
      echo bench(fn() { day5.run(lines) })
      Nil
    }
    "6" -> {
      // echo day6.run(lines)
      echo bench(fn() { day6.run(lines) })
      Nil
    }
    "7" -> {
      // echo day7.run(lines)
      echo bench(fn() { day7.run(lines) })
      Nil
    }
    "8" -> {
      // echo day8.run(lines)
      echo bench(fn() { day8.run(lines) })
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
  repeat(19, fn() {
    f()
    Nil
  })
  let stop = erlang_monotonic_time(1_000_000)

  #(
    result,
    float.to_precision({ int.to_float(stop - start) /. 1000.0 } /. 20.0, 3),
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

pub fn bench(f: fn() -> a) -> a {
  let #(result, time) = time(f)
  echo "Time taken: " <> float.to_string(time) <> " ms"
  result
}
