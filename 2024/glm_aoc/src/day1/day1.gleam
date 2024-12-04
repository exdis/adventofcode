import gleam/io
import gleam/int
import gleam/list
import gleam/string

import utils/file

fn parse_string(input: String) -> #(List(Int), List(Int)) {
    let lines = string.split(input, "\n")
    let initial_lists = #([], [])

    list.fold(lines, initial_lists, fn(res, line) {
        let #(lefts, rights) = res
        case string.split(line, "   ") {
            [left, right] -> {
                let lnum = case int.parse(left) {
                    Ok(num) -> num
                    Error(_) -> panic as "Error parsing number"
                }
                let rnum = case int.parse(right) {
                    Ok(num) -> num
                    Error(_) -> panic as "Error parsing number"
                }
                #(list.append(lefts, [lnum]), list.append(rights, [rnum]))
            }
            _ -> {
                #(lefts, rights)
            }
        }
    })
}

pub fn execute() {
    let res = file.read_input("src/day1/input.txt")
    let #(lefts, rights) = parse_string(res)
    let left_sorted = list.sort(lefts, by: int.compare)
    let right_sorted = list.sort(rights, by: int.compare)
    let sum = list.map2(left_sorted, right_sorted, fn(l, r) {
        int.max(l, r) - int.min(l, r)
    })
    let res1 = list.fold(sum, 0, fn(res, item) {
        res + item
    })
    let res2 = list.fold(left_sorted, 0, fn(res, item) {
        res + item * list.count(right_sorted, fn(r) {
            r == item
        })
    })
    io.println("Day 1 result 1: " <> int.to_string(res1))
    io.println("      result 2: " <> int.to_string(res2))
}
