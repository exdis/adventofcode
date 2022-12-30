import { getInputLines } from '../utils';

type Pos = [number, number]

const moveTail = (headPos: Pos, tailPos: Pos): Pos => {
    const xDiff = headPos[1] - tailPos[1];
    const yDiff = headPos[0] - tailPos[0];

    const result = tailPos;

    if (Math.abs(xDiff) > 1) {
        result[1] += xDiff > 0 ? 1 : -1;
        if (yDiff !== 0) {
            result[0] += yDiff > 0 ? 1 : -1;
        }
    } else if (Math.abs(yDiff) > 1) {
        result[0] += yDiff > 0 ? 1 : -1;
        if (xDiff !== 0) {
            result[1] += xDiff > 0 ? 1 : -1;
        }
    }

    return result;
}

export const run = () => {
    const input = getInputLines(9);

    let headPos: Pos = [0, 0];
    let tailPos: Pos = [0, 0];

    const visited = new Set<string>();
    visited.add(tailPos.join('_'));

    let knots: Pos[] = [];

    for (let i = 0; i < 10; i++) {
        knots[i] = [0, 0];
    }

    const visited2Part = new Set<string>();
    visited2Part.add(knots[9].join('_'))

    for (const line of input) {
        if (!line) continue;

        const [direction, amt] = line.split(' ');

        for (let i = 0; i < parseInt(amt, 10); i++) {
            switch (direction) {
                case 'U':
                    headPos[0]--;
                    knots[0][0]--;
                break;
                case 'D':
                    headPos[0]++;
                    knots[0][0]++;
                break;
                case 'L':
                    headPos[1]--;
                    knots[0][1]--;
                break;
                case 'R':
                    headPos[1]++;
                    knots[0][1]++;
                break;
            }

            tailPos = moveTail(headPos, tailPos);
            visited.add(tailPos.join('_'));

            for (let j = 1; j < knots.length; j++) {
                knots[j] = moveTail(knots[j - 1], knots[j]);
            }
            visited2Part.add(knots[9].join('_'));
        }
    }

    console.log('visited:', visited.size);
    console.log('visited2Part:', visited2Part.size);
}
