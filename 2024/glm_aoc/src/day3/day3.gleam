import gleam/io
import gleam/option.{Some}
import gleam/int
import gleam/list
import gleam/regexp

import utils/file

pub fn execute() {
    let data = file.read_input("src/day3/input.txt")

    let options = regexp.Options(case_insensitive: False, multi_line: True)
    let assert Ok(re) = regexp.compile("do\\(\\)|don't\\(\\)|mul\\(\\d+,\\d+\\)", options)
    let matches = regexp.scan(re, data)

    let #(res1, res2, _) = list.fold(matches, #(0, 0, True), fn(res, item) {
        let #(num1, num2, flag) = res
        case item.content {
            "do()" -> #(num1, num2, True)
            "don't()" -> #(num1, num2, False)
            _ -> {
                let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")

                let matches = regexp.scan(re, item.content)
                let assert Ok(first_match) = list.first(matches)

                let mul = list.fold(first_match.submatches, 1, fn(res, item) {
                    case item {
                        Some(submatch) -> {
                            let assert Ok(num) = int.parse(submatch)
                            res * num
                        }
                        _ -> res
                    }
                })

                let mul2 = case flag {
                    True -> num2 + mul
                    False -> num2
                }
                #(num1 + mul, mul2, flag)
            }
        }
    })

    io.println("Day 3 result 1: " <> int.to_string(res1))
    io.println("      result 2: " <> int.to_string(res2))
}
