use adventofcode::get_input_lines;

pub fn run() {
    let lines = get_input_lines(4);

    let mut overlaps = 0;
    let mut full_overlaps = 0;

    for (_, line) in lines.enumerate() {
        let line = line.unwrap();

        if line.len() == 0 { continue; }

        let sections: Vec<&str> = line.split(",").collect();
        let first_section: Vec<u8> = sections[0].split('-').map(|item| item.parse::<u8>().unwrap()).collect();
        let second_section: Vec<u8> = sections[1].split('-').map(|item| item.parse::<u8>().unwrap()).collect();

        if
            (first_section[0] >= second_section[0] && first_section[1] <= second_section[1]) ||
            (second_section[0] >= first_section[0] && second_section[1] <= first_section[1])
        {
            full_overlaps += 1;
            overlaps += 1;
        } else if
            (first_section[0] >= second_section[0] && first_section[0] <= second_section[1] && first_section[1] >= second_section[1]) ||
            (second_section[0] >= first_section[0] && second_section[0] <= first_section[1] && second_section[1] >= first_section[1])
        {
            overlaps += 1;
        }
    }

    println!("Full overlaps: {full_overlaps}");
    println!("Overlaps: {overlaps}");
}
