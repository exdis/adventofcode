import { getInputLines } from '../utils';

type Item = 'A' | 'B' | 'C' | 'X' | 'Y' | 'Z';

const WIN_SCORE = 6;
const DRAW_SCORE = 3;

const scoreMap: Map<Item, {
    wins: Item,
    draw: Item,
    loose: Item,
    score: number,
    strategy?: string
}> = new Map([
    ['A', { wins: 'Z', draw: 'X', loose: 'Y', score: 1 }],
    ['B', { wins: 'X', draw: 'Y', loose: 'Z', score: 2 }],
    ['C', { wins: 'Y', draw: 'Z', loose: 'X', score: 3 }],
    ['X', { wins: 'C', draw: 'A', loose: 'B', score: 1, strategy: 'loose' }],
    ['Y', { wins: 'A', draw: 'B', loose: 'C', score: 2, strategy: 'draw' }],
    ['Z', { wins: 'B', draw: 'C', loose: 'A', score: 3, strategy: 'win' }]
])

export const run = () => {
    let score = 0;
    let alternativeScore = 0;

    const input = getInputLines(2);

    for (const item of input) {
        const [opponent, me] = item.split(' ') as Item[];

        if (!me || !opponent) {
            continue;
        }

        const scoreMapItem = scoreMap.get(me);

        score += scoreMapItem.score;

        switch (scoreMapItem.strategy) {
            case 'draw':
                alternativeScore += DRAW_SCORE;
                alternativeScore += scoreMap.get(scoreMap.get(opponent).draw).score;
                break;
            case 'win':
                alternativeScore += WIN_SCORE;
                alternativeScore += scoreMap.get(scoreMap.get(opponent).loose).score;
                break;
            case 'loose':
                alternativeScore += scoreMap.get(scoreMap.get(opponent).wins).score;
                break;
        }

        if (scoreMapItem.draw === opponent) {
            score += DRAW_SCORE;
        }

        if (scoreMapItem.wins === opponent) {
            score += WIN_SCORE;
        }
    }

    console.log('Score:', score);
    console.log('AlternativeScore:', alternativeScore);
};

