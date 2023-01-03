use std::fs::File;
use std::io::{BufRead, BufReader};

pub fn get_input_lines(day: u8) -> Vec<String> {
    let input = File::open(format!("src/day{}/input.txt", day)).unwrap();
    BufReader::new(input).lines().map(|line| line.unwrap()).collect()
}
