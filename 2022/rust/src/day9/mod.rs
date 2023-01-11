use std::collections::HashSet;
use adventofcode::get_input_lines;

fn move_tail(head_pos: [i32; 2], tail_pos: [i32; 2]) -> [i32; 2] {
    let xdiff = head_pos[1] - tail_pos[1];
    let ydiff = head_pos[0] - tail_pos[0];

    let mut result: [i32; 2] = tail_pos;

    if xdiff.abs() > 1 {
        result[1] += if xdiff > 0 { 1 } else { - 1};
        if ydiff != 0 {
            result[0] += if ydiff > 0 { 1 } else { - 1};
        }
    } else if ydiff.abs() > 1 {
        result[0] += if ydiff > 0 { 1 } else { - 1};
        if xdiff != 0 {
            result[1] += if xdiff > 0 { 1 } else { - 1};
        }
    }

    return result;
}

pub fn run() {
    let input = get_input_lines(9);

    let mut head_pos = [0, 0];
    let mut tail_pos = [0, 0];

    let mut visited: HashSet<String> = HashSet::new();
    visited.insert(tail_pos.map(|i| i.to_string()).join("_"));

    let mut knots: Vec<[i32; 2]> = vec![];

    for _ in 0..10 {
        knots.push([0, 0]);
    }

    let mut visited_2_part: HashSet<String> = HashSet::new();
    visited_2_part.insert(knots[9].map(|i| i.to_string()).join("_"));

    for line in input {
        if line.len() == 0 { continue; }

        let splitted: Vec<&str> = line.split(" ").collect();
        let direction = splitted[0];
        let amt: i32 = splitted[1].parse().unwrap();

        for _ in 0..amt {
            match direction {
                "U" => {
                    head_pos[0] -= 1;
                    knots[0][0] -= 1;
                },
                "D" => {
                    head_pos[0] += 1;
                    knots[0][0] += 1;
                },
                "L" => {
                    head_pos[1] -= 1;
                    knots[0][1] -= 1;
                },
                "R" => {
                    head_pos[1] += 1;
                    knots[0][1] += 1;
                },
                _ => continue,
            }

            tail_pos = move_tail(head_pos, tail_pos);
            visited.insert(tail_pos.map(|i| i.to_string()).join("_"));

            for j in 1..knots.len() {
                knots[j] = move_tail(knots[j - 1], knots[j]);
            }
            visited_2_part.insert(knots[9].map(|i| i.to_string()).join("_"));
        }
    }

    println!("Visited: {}", visited.len());
    println!("Visited 2 part: {}", visited_2_part.len());
}
