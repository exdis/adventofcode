use adventofcode::get_input_lines;

pub fn run() {

    let mut max = 0;
    let mut sum = 0;

    let mut calories: Vec<i32> = Vec::new();

    for (_, line) in get_input_lines(1).enumerate() {
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
