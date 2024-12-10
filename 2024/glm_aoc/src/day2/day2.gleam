import gleam/io
import gleam/int
import gleam/list
import gleam/string

import utils/file

fn parse_string(input: String) -> List(List(Int)) {
    let lines = string.split(input, "\n")

    list.fold(lines, [], fn(res, line) {
        let splitted = string.split(line, " ")
        case line {
            "" -> res
            _ -> {
                let splitted_parsed = list.map(splitted, fn(s) {
                    case int.parse(s) {
                        Ok(num) -> num
                        Error(_) -> panic as "Error parsing number"
                    }
                })
                list.append(res, [splitted_parsed])
            }
        }
    })
}

fn check_report(report: List(Int)) -> #(Bool, Int) {
    let #(decreasing, increasing, level, _, last_failed) = list.index_fold(report, #(True, True, True, 0, -1), fn(res, item, idx) {
        let #(dec, inc, lev, num, last) = res
        let decreasing = dec && {item < num || num == 0}
        let increasing = inc && {item > num || num == 0}
        let prev_diff = lev
        let diff = int.absolute_value(num - item)
        let level = prev_diff && {{diff > 0 && diff <= 3} || num == 0}
        case item {
            0 -> #(True, True, True, item, last)
            _ -> {
                let new_last_failed = case {increasing || decreasing} && level {
                    True -> last
                    False -> {
                        case last {
                            -1 -> idx - 1
                            _ -> last
                        }
                    }
                }
                #(decreasing, increasing, level, item, new_last_failed)
            }
        }
    })

    #({increasing || decreasing} && level, last_failed)
}

pub fn execute() {
    let data = file.read_input("src/day2/input.txt")
    let parsed = parse_string(data)

    let #(res1, res2) = list.fold(parsed, #(0, 0), fn(safe, item) {
        let #(safe1, safe2) = safe
        let #(is_safe, last_failed) = check_report(item)

        case is_safe {
            True -> {
                #(safe1 + 1, safe2 + 1)
            }
            False -> {
                let #(head_one, rest_one) = list.split(item, last_failed)
                let #(head_two, rest_two) = list.split(item, last_failed + 1)
                let #(head_three, rest_three) = list.split(item, last_failed - 1)
                let assert Ok(tail_one) = list.rest(rest_one)
                let assert Ok(tail_two) = list.rest(rest_two)
                let assert Ok(tail_three) = list.rest(rest_three)
                let #(filtered_one, _) = check_report(list.append(head_one, tail_one))
                let #(filtered_two, _) = check_report(list.append(head_two, tail_two))
                let #(filtered_three, _) = check_report(list.append(head_three, tail_three))
                case filtered_one || filtered_two || filtered_three {
                    True -> #(safe1, safe2 + 1)
                    False -> #(safe1, safe2)
                }
            }
        }
    })

    io.println("Day 2 result 1: " <> int.to_string(res1))
    io.println("      result 2: " <> int.to_string(res2))
}
