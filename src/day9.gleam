import gleam/int
import gleam/list
import gleam/pair.{first, second}
import gleam/result.{unwrap}
import helper

pub fn run(lines: List(String)) {
  let points =
    list.map(lines, fn(line) {
      case helper.take_ints(line, ",") {
        [x, y] -> #(x, y)
        _ -> panic
      }
    })

  let areas =
    points
    |> list.combination_pairs()
    |> list.map(fn(v) {
      let #(#(x1, y1), #(x2, y2)) = v
      let x_dist = int.absolute_value(x2 - x1) + 1
      let y_dist = int.absolute_value(y2 - y1) + 1
      #(v, x_dist * y_dist)
    })
    |> list.sort(fn(l, r) { int.compare(second(r), second(l)) })

  let p1 = case areas {
    [v, ..] -> pair.second(v)
    _ -> panic
  }

  let points = [unwrap(list.last(points), #(0, 0)), ..points]
  let horizontal = horizontal_segments(points)
  let vertical = vertical_segments(points)

  let p2_area =
    list.find(areas, fn(area) {
      let #(rectangle, _) = area
      is_inside_polygon(rectangle, horizontal, vertical)
    })

  let p2 = case p2_area {
    Ok(v) -> second(v)
    _ -> panic
  }

  #(p1, p2)
}

fn is_inside_polygon(rectangle, horizontal, vertical) {
  let #(#(x1, y1), #(x2, y2)) = rectangle
  let xmin = int.min(x1, x2)
  let xmax = int.max(x1, x2)
  let ymin = int.min(y1, y2)
  let ymax = int.max(y1, y2)

  !intersects(ymin, False, xmin, xmax, vertical)
  && !intersects(ymax, True, xmin, xmax, vertical)
  && !intersects(xmin, False, ymin, ymax, horizontal)
  && !intersects(xmax, True, ymin, ymax, horizontal)
}

fn intersects(c, c_is_max, pmin, pmax, segments) {
  case segments {
    [#(c_seg, #(left, right)), ..ts] -> {
      //Check if they intersect
      case
        c_seg > pmin
        && c_seg < pmax
        && {
          { c_is_max && c > left && c <= right }
          || { !c_is_max && c >= left && c < right }
        }
      {
        True -> True
        False ->
          // Since the segments are sorted. Once we've passed pmax no future segment would pass the test
          case c_seg >= pmax {
            True -> False
            False -> intersects(c, c_is_max, pmin, pmax, ts)
          }
      }
    }
    _ -> False
  }
}

// All horizontal segments of the polygon sorted by their leftmost point
fn horizontal_segments(points) {
  list.window_by_2(points)
  |> list.filter(fn(ps) { second(first(ps)) == second(second(ps)) })
  |> list.map(fn(ps) {
    let y = second(first(ps))
    let x1 = first(first(ps))
    let x2 = first(second(ps))
    #(y, #(int.min(x1, x2), int.max(x1, x2)))
  })
  |> list.sort(fn(l, r) { int.compare(first(l), first(r)) })
}

// All vertical segments of the polygon sorted by their uppermost point
fn vertical_segments(points) {
  list.window_by_2(points)
  |> list.filter(fn(ps) { first(first(ps)) == first(second(ps)) })
  |> list.map(fn(ps) {
    let x = first(first(ps))
    let y1 = second(first(ps))
    let y2 = second(second(ps))
    #(x, #(int.min(y1, y2), int.max(y1, y2)))
  })
  |> list.sort(fn(l, r) { int.compare(first(l), first(r)) })
}
