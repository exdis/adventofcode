use regex::Regex;
use std::collections::HashMap;
use adventofcode::get_input_lines;

#[derive(Debug)]
enum NodeType {
    Dir,
    File
}

#[derive(Debug)]
struct PathNode {
    id: usize,
    path: String,
    node_type: NodeType,
    pub size: i32,
    children: Vec<usize>,
    parent: usize,
}

pub fn run() {
    let input = get_input_lines(7);

    let mut sum_size = 0;
    let mut dir_sizes: HashMap<usize, i32> = HashMap::new();

    let tree = PathNode {
        id: 1,
        path: String::from("/"),
        node_type: NodeType::Dir,
        size: 0,
        children: vec![],
        parent: 0,
    };

    let mut node_index: HashMap<usize, PathNode> = HashMap::new();

    node_index.insert(tree.id, tree);

    let mut current_node: usize = 1;
    let mut last_idx: usize = 1;

    fn count_total_size(
        tree_id: usize,
        node_index: &HashMap<usize, PathNode>,
        dir_sizes: &mut HashMap<usize, i32>,
    ) -> i32 {
        let mut sum = 0;
        let node = node_index.get(&tree_id).unwrap();

        for child in &node.children {
            let child = node_index.get(&child).unwrap();

            match child.node_type {
                NodeType::File => sum += child.size,
                NodeType::Dir => {
                    let dir_size = count_total_size(child.id, node_index, dir_sizes);
                    dir_sizes.insert(child.id, dir_size);
                    sum += dir_size;
                }
            }
        }

        return sum;
    }

    for line in input {
        if line.len() == 0 { continue; }

        if line == "$ cd /" {
            continue;
        }

        if line == "$ ls" { continue; }

        let re = Regex::new(r"^\$ cd (.*)").unwrap();

        let captures: Vec<regex::Captures> = re.captures_iter(line.as_str()).collect();

        let dir_to_change = match captures.iter().nth(0) {
            Some(cap) => &cap[1],
            None => ""
        };

        if dir_to_change != "" {
            if dir_to_change == ".." {
                current_node = node_index.get(&current_node).unwrap().parent;
            } else {
                let node = node_index.get(&current_node).unwrap();
                let child_id = node.children
                    .iter()
                    .find(|c| node_index.get(c).unwrap().path == dir_to_change)
                    .unwrap();

                current_node = *child_id;
            }

            continue;
        }

        let splitted: Vec<String> = line.split(' ').map(String::from).collect();
        let node_type = if splitted[0] == "dir" { NodeType::Dir } else { NodeType::File };
        let size = if splitted[0] != "dir" { splitted[0].parse().unwrap() } else { 0 };

        last_idx += 1;

        let child = PathNode {
            id: last_idx,
            path: splitted[1].clone(),
            node_type,
            size,
            children: vec![],
            parent: current_node,
        };

        node_index.insert(last_idx, child);

        let node = node_index.get_mut(&current_node).unwrap();
        node.children.push(last_idx);
    }

    let tree_size = count_total_size(1, &node_index, &mut dir_sizes);

    for (_, size) in &dir_sizes {
        if size <= &100000 {
            sum_size += size;
        }
    }

    let mut dir_to_delete = 0;
    let space_to_free = 30000000 - (70000000 - tree_size);

    let mut dir_sizes_sorted: Vec<&i32> = dir_sizes.values().collect();
    dir_sizes_sorted.sort();

    for size in dir_sizes_sorted {
        if size >= &space_to_free {
            dir_to_delete = *size;
            break;
        }
    }

    println!("Sum size, {sum_size}");
    println!("Dir size to delete, {dir_to_delete}");
}
