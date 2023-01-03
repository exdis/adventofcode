use std::io;
use std::env;

mod day1;
mod day2;
mod day3;
mod day4;
mod day5;
mod day6;

fn main() {
    let day_from_args = match env::args().nth(1) {
        Some(day) => day,
        None => String::from("0")
    };
    let day_from_args: u8 = match day_from_args.trim().parse::<u8>() {
        Ok(num) => num,
        Err(_) => 0
    };

    let day: u8 = if day_from_args > 0 { day_from_args } else {
        loop {
            let mut day = String::new();

            println!("Specify day:");

            io::stdin().read_line(&mut day).expect("Error!");

            match day.trim().parse::<u8>() {
                Ok(num) => { break num },
                Err(_) => {
                    println!("Wrong day specified!");
                    continue;
                }
            };
        }
    };

    match day {
        1 => day1::run(),
        2 => day2::run(),
        3 => day3::run(),
        4 => day4::run(),
        5 => day5::run(),
        6 => day6::run(),
        _ => println!("Wrong day specified!")
    };
}
