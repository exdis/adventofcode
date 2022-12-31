use std::collections::HashMap;
use adventofcode::get_input_lines;

const WIN_SCORE: u32 = 6;
const DRAW_SCORE: u32 = 3;

pub fn run() {
    let mut score: u32 = 0;
    let mut alternative_score: u32 = 0;

    enum Strategy {
        Loose,
        Draw,
        Win
    }

    struct ScoreMap {
        wins: char,
        draw: char,
        loose: char,
        score: u32,
        strategy: Strategy,
    }

    let mut score_map = HashMap::<char, ScoreMap>::new();

    score_map.insert('A', ScoreMap { wins: 'Z', draw: 'X', loose: 'Y', score: 1, strategy: Strategy::Win });
    score_map.insert('B', ScoreMap { wins: 'X', draw: 'Y', loose: 'Z', score: 2, strategy: Strategy::Win });
    score_map.insert('C', ScoreMap { wins: 'Y', draw: 'Z', loose: 'X', score: 3, strategy: Strategy::Win });
    score_map.insert('X', ScoreMap { wins: 'C', draw: 'A', loose: 'B', score: 1, strategy: Strategy::Loose });
    score_map.insert('Y', ScoreMap { wins: 'A', draw: 'B', loose: 'C', score: 2, strategy: Strategy::Draw });
    score_map.insert('Z', ScoreMap { wins: 'B', draw: 'C', loose: 'A', score: 3, strategy: Strategy::Win });

    for (_, line) in get_input_lines(2).enumerate() {
        let line = line.unwrap();

        if line.len() == 0 { continue; }

        let opponent = line.chars().nth(0).unwrap();
        let me = line.chars().nth(2).unwrap();

        let score_map_item = score_map.get(&me).unwrap();
        let score_opponent_item = score_map.get(&opponent).unwrap();

        score += score_map_item.score;

        match &score_map_item.strategy {
            Strategy::Draw => {
                alternative_score += DRAW_SCORE;
                alternative_score += score_map.get(&score_opponent_item.draw).unwrap().score;
            },
            Strategy::Win => {
                alternative_score += WIN_SCORE;
                alternative_score += score_map.get(&score_opponent_item.loose).unwrap().score;
            },
            Strategy::Loose => {
                alternative_score += score_map.get(&score_opponent_item.wins).unwrap().score;
            }
        }

        if score_map_item.draw == opponent {
            score += DRAW_SCORE;
        }

        if score_map_item.wins == opponent {
            score += WIN_SCORE;
        }
    }

    println!("Score: {score}");
    println!("Alternative score: {alternative_score}");
}
