use adventofcode::get_input_lines;
use std::collections::HashSet;

pub fn run() {
    let input = get_input_lines(6);
    let chars = input.get(0).unwrap().chars();

    let mut set: HashSet<char> = HashSet::new();
    let mut set_part_two: HashSet<char> = HashSet::new();

    let mut result = 0;
    let mut result_part_two = 0;

    for (i, c) in chars.enumerate() {
        if set.contains(&c) {
            set.clear();
        }

        if set_part_two.contains(&c) {
            set_part_two.clear();
        }

        set.insert(c);
        set_part_two.insert(c);

        if set.len() == 4 && result == 0 {
            result = i + 1;
        }

        if set_part_two.len() == 14 && result_part_two == 0 {
            result_part_two = i + 1;
        }
    }

    println!("Result: {result}");
    println!("Result part 2: {result_part_two}");
}
