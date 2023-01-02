use regex::Regex;
use adventofcode::get_input_lines;

pub fn run() {
    let input: Vec<String> = get_input_lines(5).map(|item| item.unwrap()).collect();

    let idx = input.iter().position(|item| item.len() == 0).unwrap();

    let mut stacks: Vec<Vec<char>> = vec![];
    let mut stacks_part_two: Vec<Vec<char>> = vec![];

    for _ in 0..9 {
        stacks.push(vec![]);
        stacks_part_two.push(vec![]);
    }

    for (i, line) in input.iter().enumerate() {
        if i == idx - 1 { break; }

        for j in 0..((line.len() + 1) / 4) {
            let c = line.chars().nth(1 + j * 4).unwrap();

            if c != ' ' {
                stacks.iter_mut().nth(j).unwrap().push(c);
                stacks_part_two.iter_mut().nth(j).unwrap().push(c);
            }
        }
    }

    for i in 0..9 {
        stacks.iter_mut().nth(i).unwrap().reverse();
        stacks_part_two.iter_mut().nth(i).unwrap().reverse();
    }

    let mut i = 0;

    while i < input.len() - idx - 1 {
        let instruction = input.iter().nth(idx + i + 1).unwrap();

        let re = Regex::new(r"move (\d+) from (\d+) to (\d+)").unwrap();

        let captures: Vec<regex::Captures> = re.captures_iter(instruction).collect();

        let capture = match captures.iter().nth(0) {
            Some(cap) => cap,
            None => break
        };

        let qty = &capture[1].parse::<usize>().unwrap();
        let from = &capture[2].parse::<usize>().unwrap();
        let to = &capture[3].parse::<usize>().unwrap();

        for _ in 0..*qty {
            let item = match stacks.iter_mut().nth(from - 1) {
                Some(stack) => {
                    match stack.pop() {
                        Some(s) => s,
                        None => continue,
                    }
                },
                None => continue,
            };
            match stacks.iter_mut().nth(to - 1) {
                Some(stack) => {
                    stack.push(item);
                },
                None => continue,
            }
        }

        let mut to_move = match stacks_part_two.iter_mut().nth(from - 1) {
            Some(stack) => stack.split_off(stack.len() - qty),
            None => continue,
        };
        match stacks_part_two.iter_mut().nth(to - 1) {
            Some(stack) => stack.append(&mut to_move),
            None => continue,
        };

        i += 1;
    }

    let mut res = String::from("");

    for stack in stacks {
        let last = match stack.iter().last() {
            Some(c) => *c,
            None => '\0'
        };
        res.push(last);
    }

    let mut res_part_two = String::from("");

    for stack in stacks_part_two {
        let last = match stack.iter().last() {
            Some(c) => *c,
            None => '\0'
        };
        res_part_two.push(last);
    }

    println!("Result: {res}");
    println!("Result part 2: {res_part_two}");
}
