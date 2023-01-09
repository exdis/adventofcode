use adventofcode::get_input_lines;

pub fn run() {
    let input = get_input_lines(8);

    let mut field: Vec<Vec<u8>> = vec![];

    let mut visible = 0;
    let mut max_scenic_score = 0;

    for line in input {

        if line.len() == 0 { continue; }

        let chars: Vec<char> = line.chars().collect();
        let nums: Vec<u8> = chars.iter().map(|c| c.to_string().parse::<u8>().unwrap()).collect();

        field.push(nums);
    }

    for (i, _) in field.iter().enumerate() {
        for (j, _) in field[i].iter().enumerate() {
            let tree = field[i][j];

            // top
            let mut top_visible = true;
            let mut top_scenic_score = 0;
            if i > 0 {
                for k in (0..i).rev() {
                    if top_visible {
                        top_scenic_score += 1;
                    }
                    if field[k][j] >= tree {
                        top_visible = false;
                        break;
                    }
                }
            }

            // bottom
            let mut bottom_visible = true;
            let mut bottom_scenic_score = 0;
            if i < field.len() {
                for k in (i + 1)..field.len() {
                    if bottom_visible {
                        bottom_scenic_score += 1;
                    }
                    if field[k][j] >= tree {
                        bottom_visible = false;
                        break;
                    }
                }
            }

            // left
            let mut left_visible = true;
            let mut left_scenic_score = 0;
            if j > 0 {
                for k in (0..j).rev() {
                    if left_visible {
                        left_scenic_score += 1;
                    }
                    if field[i][k] >= tree {
                        left_visible = false;
                        break;
                    }
                }
            }

            // right
            let mut right_visible = true;
            let mut right_scenic_score = 0;
            if j < field.len() {
                for k in (j + 1)..field.len() {
                    if right_visible {
                        right_scenic_score += 1;
                    }
                    if field[i][k] >= tree {
                        right_visible = false;
                        break;
                    }
                }
            }

            let scenic_score = top_scenic_score * bottom_scenic_score * left_scenic_score * right_scenic_score;

            if scenic_score > max_scenic_score {
                max_scenic_score = scenic_score;
            }

            if top_visible || bottom_visible || left_visible || right_visible {
                visible += 1;
            }
        }
    }

    println!("Result {visible}");
    println!("Max scenic score {max_scenic_score}");
}
