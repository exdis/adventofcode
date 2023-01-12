use adventofcode::get_input_lines;

pub fn run() {
    let binding = get_input_lines(10);
    let mut queue: Vec<&String> = binding
        .iter()
        .filter(|item| item.len() > 0)
        .rev()
        .collect();

    let mut x: i32 = 1;
    let mut cycles: i32 = 1;
    let mut local_cycles: i32 = 0;
    let mut strength_sum: i32 = 0;

    let mut pixels: Vec<Vec<char>> = vec![];

    for _ in 0..6 {
        pixels.push(".".repeat(40).chars().collect::<Vec<char>>());
    }

    let mut sprite = ".".repeat(40).chars().collect::<Vec<char>>();
    sprite[0] = '#';
    sprite[1] = '#';
    sprite[2] = '#';

    while queue.len() > 0 {
        if
            cycles == 20 ||
            cycles == 60 ||
            cycles == 100 ||
            cycles == 140 ||
            cycles == 180 ||
            cycles == 220
        {
            strength_sum += cycles * x;
            println!("{cycles}th cycle, X: {x}, strength: {}", cycles * x);
        }

        let command = queue.pop().unwrap();

        let line = (cycles - 1) / 40;
        let pixel = cycles - 1 - line * 40;

        if sprite[pixel as usize] == '#' {
            pixels[line as usize][pixel as usize] = '#';
        }

        if command == "noop" {
            cycles += 1;
            continue;
        }

        if local_cycles == 0 {
            queue.push(command);
            local_cycles += 1;
            cycles += 1;
            continue;
        }

        if local_cycles == 1 {
            local_cycles = 0;

            let amt: i32 = command.replace("addx ", "").parse().unwrap();

            x += amt;

            sprite.fill('.');

            if x - 1 >= 0 && x - 1 < sprite.len() as i32 {
                sprite[(x - 1) as usize] = '#';
            }
            if x >= 0 && x < sprite.len() as i32 {
                sprite[x as usize] = '#';
            }
            if x + 1 >= 0 && x + 1 < sprite.len() as i32 {
                sprite[(x + 1) as usize] = '#';
            }

            cycles += 1;
        }
    }

    println!("Strength sum: {strength_sum}");

    for line in pixels {
        println!("{}", line.iter().map(|c| c.to_string()).collect::<Vec<String>>().join(""));
    }
}
