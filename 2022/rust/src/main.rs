use std::io;

mod day1;
mod day2;
mod day3;

fn main() {
    let day: u8 = loop {
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
    };

    match day {
        1 => day1::run(),
        2 => day2::run(),
        3 => day3::run(),
        _ => println!("Wrong day specified!")
    };
}
