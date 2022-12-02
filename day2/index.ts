import path from 'path';
import fs from 'fs';

type Item = 'A' | 'B' | 'C' | 'X' | 'Y' | 'Z';

const WIN_SCORE = 6;
const DRAW_SCORE = 3;

const scoreMap: Map<Item, { wins: Item, draw: Item, score: number }> = new Map([
    ['A', { wins: 'Z', draw: 'X', score: 1 }],
    ['B', { wins: 'X', draw: 'Y', score: 2 }],
    ['C', { wins: 'Y', draw: 'Z', score: 3 }],
    ['X', { wins: 'C', draw: 'A', score: 1 }],
    ['Y', { wins: 'A', draw: 'B', score: 2 }],
    ['Z', { wins: 'B', draw: 'C', score: 3 }]
])

export const run = () => {
    let score = 0;

    const input = fs.readFileSync(path.join(__dirname, 'input.txt'))
        .toString()
        .split('\n');

    for (const item of input) {
        const [opponent, me] = item.split(' ') as Item[];

        if (!me || !opponent) {
            continue;
        }

        const scoreMapItem = scoreMap.get(me);

        score += scoreMapItem.score;

        if (scoreMapItem.draw === opponent) {
            score += DRAW_SCORE;
        }

        if (scoreMapItem.wins === opponent) {
            score += WIN_SCORE;
        }
    }

    console.log('Score:', score);
};

