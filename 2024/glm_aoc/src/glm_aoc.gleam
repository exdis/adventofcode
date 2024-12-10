import gleam/io
import clip/help
import clip
import clip/arg
import argv

import day1/day1
import day2/day2
import day3/day3

fn command() {
    clip.command({
        use day <- clip.parameter
        day
    })
    |> clip.arg(arg.new("day") |> arg.int |> arg.help("Day to run"))
}

fn run_day(day) {
    case day {
        1 -> day1.execute()
        2 -> day2.execute()
        3 -> day3.execute()
        _ -> io.println("Day not implemented")
    }
}

pub fn main() {
    let day = command()
    |> clip.help(help.simple("Day", "Advent of Code 2024"))
    |> clip.run(argv.load().arguments)

    case day {
        Error(e) -> io.println("Error: " <> e)
        Ok(d) -> run_day(d)
    }
}
