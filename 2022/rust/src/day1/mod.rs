use std::fs::File;
use std::io::{BufRead, BufReader};

pub fn run() {
    let input = File::open("src/day1/input.txt").unwrap();
    let reader = BufReader::new(input);

    let mut max = 0;
    let mut sum = 0;

    let mut calories: Vec<i32> = Vec::new();

    for (_, line) in reader.lines().enumerate() {
        let line = line.unwrap();

        if line.len() != 0 {
            sum = sum + line.parse::<i32>().unwrap();
        } else {
            if sum > max {
                max = sum;
            }
            calories.push(sum);
            sum = 0;
        }
    }

    calories.sort_by(|a, b| b.cmp(a));

    println!("max: {max}");
    println!("top 3: {}", calories[0] + calories[1] + calories[2]);
}
