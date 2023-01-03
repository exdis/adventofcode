use std::collections::HashSet;
use adventofcode::get_input_lines;

fn get_item_priority(item: char) -> u32 {
    if item == item.to_ascii_uppercase() {
        return item as u32 - 38;
    } else {
        return item as u32 - 96;
    }
}

pub fn run() {
    let mut sum = 0;
    let mut group_sum = 0;
    let mut cnt = 0;

    let mut sets = Vec::<HashSet::<char>>::new();

    for _ in 0..3 {
        sets.push(HashSet::<char>::new());
    }

    for line in get_input_lines(3) {
        if line.len() == 0 { continue; }

        let mut first_compartment = HashSet::<char>::new();
        let mut second_compartment = HashSet::<char>::new();

        for (idx, item) in line.chars().enumerate() {
            if idx < line.len() / 2 {
                first_compartment.insert(item);
            } else {
                second_compartment.insert(item);
            }

            sets[cnt].insert(item);
        }

        for (_, item) in first_compartment.intersection(&second_compartment).enumerate() {
            sum += get_item_priority(item.clone());
        }

        if cnt == 2 {
            let intersection = sets[0].iter().filter(|item| sets[1].contains(item) && sets[2].contains(item));

            for (_, item) in intersection.enumerate() {
                group_sum += get_item_priority(item.clone());
            }

            sets.iter_mut().for_each(|set| set.clear());
            cnt = 0;
        } else {
            cnt += 1;
        }
    }

    println!("Sum: {sum}");
    println!("Group sum: {group_sum}");
}
