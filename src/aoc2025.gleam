import argv
import day1
import gleam/float
import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  case run() {
    Ok(_) -> io.println("Success!")
    Error(error) -> io.println_error(error)
  }
}

fn run() -> Result(String, String) {
  use day <- result.try(get_day_arg())
  use contents <- result.try(get_file_contents(day))
  let result = case day {
    "1" -> {
      let lines = string.split(contents, "\n")
      let #(p1, p2) = day1.run(lines)
      Ok(int.to_string(p1) <> " " <> int.to_string(p2))
      // let #(result, time_in_ms) = time(fn() { day1.run(lines) })
      // io.println("Time taken: " <> float.to_string(time_in_ms) <> " ms")
      // result
    }
    _ -> Error("This day has not yet been implemented")
  }

  case result {
    Ok(r) -> io.println("Result: " <> r)
    Error(r) -> io.println_error("Something went wrong: " <> r)
  }

  Ok("Finished computation")
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
