use evalexpr::*;
use std::collections::HashMap;
use adventofcode::get_input_lines;

struct Monkey {
    id: i32,
    operation: String,
    test: i64,
    if_true: i32,
    if_false: i32,
}

impl Monkey {
    fn new(
        id: i32,
        operation: String,
        test: i64,
        if_true: i32,
        if_false: i32,
    ) -> Monkey {
        Monkey {
            id,
            operation,
            test,
            if_true,
            if_false
        }
    }
}

pub fn run() {
    let input = get_input_lines(11);
    let input: Vec<&String> = input.iter().filter(|line| line.len() > 0).collect();

    let mut monkeys: Vec<Monkey> = vec![];

    let mut supermodulo: i64 = 1;

    let mut monkey_items: HashMap<i32, Vec<i64>> = HashMap::new();
    let mut monkey_items_2: HashMap<i32, Vec<i64>> = HashMap::new();
    let mut monkey_inspections: HashMap<i32, i64> = HashMap::new();
    let mut monkey_inspections_2: HashMap<i32, i64> = HashMap::new();

    fn test_item(
        monkey_id: i32,
        item: i64,
        monkeys: &Vec<Monkey>,
    ) -> i32 {
        let monkey = monkeys.get(monkey_id as usize).unwrap();

        if item % monkey.test == 0 {
            monkey.if_true
        } else {
            monkey.if_false
        }
    }

    fn operate(
        monkey_id: i32,
        divide_by_3: bool,
        supermodulo: i64,
        monkeys: &Vec<Monkey>,
        monkey_items: &HashMap<i32, Vec<i64>>
    ) -> Option<i64> {
        let items = monkey_items.get(&monkey_id).unwrap();
        let monkey = monkeys.get(monkey_id as usize).unwrap();

        if items.len() > 0 {
            let mut item = items[0];

            item = if supermodulo > 1 { item % supermodulo } else { item };

            let operation = monkey.operation.replace("new = ", "");
            let operation = operation.replace("old", item.to_string().as_str());

            let mut new_item: i64 = match eval_int(&operation) {
                Ok(num) => i64::try_from(num).ok().unwrap(),
                Err(_) => 0,
            };

            if divide_by_3 {
                new_item = new_item / 3;
            }

            return Some(new_item)
        }

        None
    }


    for i in 0..(input.len() / 5) {
        let monkey = i * 6;

        match input.get(monkey + 1) {
            Some(_) => {
                let items: Vec<i64> = input[monkey + 1]
                    .replace("  Starting items: ", "")
                    .split(", ")
                    .map(|i| i.parse::<i64>().ok().unwrap())
                    .collect();

                let operation = input[monkey + 2]
                    .replace("  Operation: ", "");

                let test: i64 = input[monkey + 3]
                    .replace("  Test: divisible by ", "")
                    .parse().ok().unwrap();

                let if_true: i32 = input[monkey + 4]
                    .replace("    If true: throw to monkey ", "")
                    .parse().ok().unwrap();

                let if_false: i32 = input[monkey + 5]
                    .replace("    If false: throw to monkey ", "")
                    .parse().ok().unwrap();

                monkey_items.insert(i as i32, items.clone());
                monkey_items_2.insert(i as i32, items.clone());

                monkey_inspections.insert(i as i32, 0);
                monkey_inspections_2.insert(i as i32, 0);

                monkeys.push(Monkey::new(
                        i as i32,
                        operation.clone(),
                        test,
                        if_true,
                        if_false
                ));

                supermodulo *= test;
            },
            None => break,
        }
    }

    for _ in 0..20 {
        for monkey in &monkeys {
            loop {
                let items = &mut monkey_items;
                if items.get(&monkey.id).unwrap().len() == 0 { break; }
                let new_item = operate(monkey.id, true, 1, &monkeys, &items).unwrap();
                let inspections_count = monkey_inspections.get(&monkey.id).unwrap();
                monkey_inspections.insert(monkey.id, inspections_count + 1);
                let monkey_idx = test_item(monkey.id, new_item, &monkeys);
                items.get_mut(&monkey.id).unwrap().remove(0);
                items.get_mut(&monkey_idx).unwrap().push(new_item);
            }
        }
    }

    let mut inspections_count: Vec<&i64> = monkey_inspections.values().collect();

    inspections_count.sort_by(|a, b| b.cmp(&a));

    println!("Result: {}", inspections_count[0] * inspections_count[1]);

    for _ in 0..10000 {
        for monkey in &monkeys {
            loop {
                let items = &mut monkey_items_2;
                if items.get(&monkey.id).unwrap().len() == 0 { break; }
                let new_item = operate(monkey.id, false, supermodulo, &monkeys, &items).unwrap();
                let inspections_count = monkey_inspections_2.get(&monkey.id).unwrap();
                monkey_inspections_2.insert(monkey.id, inspections_count + 1);
                let monkey_idx = test_item(monkey.id, new_item, &monkeys);
                items.get_mut(&monkey.id).unwrap().remove(0);
                items.get_mut(&monkey_idx).unwrap().push(new_item);
            }
        }
    }

    let mut inspections_count: Vec<&i64> = monkey_inspections_2.values().collect();

    inspections_count.sort_by(|a, b| b.cmp(&a));

    println!("Result part 2: {}", inspections_count[0] * inspections_count[1]);
}
