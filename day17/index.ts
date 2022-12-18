import { getInputLines } from '../utils';

const ROCKS = [
    [
        ['#', '#', '#', '#']
    ],
    [
        ['.', '#', '.'],
        ['#', '#', '#'],
        ['.', '#', '.'],
    ],
    [
        ['.', '.', '#'],
        ['.', '.', '#'],
        ['#', '#', '#'],
    ],
    [
        ['#'],
        ['#'],
        ['#'],
        ['#'],
    ],
    [
        ['#', '#'],
        ['#', '#'],
    ]
];

const MAX_ROCKS = 2022;
// const MAX_ROCKS_PART_2 = 1000_000_000_000;

const getCoords = (rock: typeof ROCKS[0], yCoord: number, centerX: number) => {
    const coords = [];

    for (let j = 0; j < rock.length; j++) {
        for (let k = 0; k < rock[j].length; k++) {
            if (rock[j][k] === '#') {
                coords.push([yCoord - j, centerX + k]);
            }
        }
    }

    return coords;
}

export const run = () => {
    const input = getInputLines(17)[0];

    const calculate = (maxRocks: number) => {
        const map = new Set<string>();

        let windIdx = -1;

        let height = 1;

        for (let i = 0; i < maxRocks; i++) {
            if (i % 1000_000 === 0) {
                console.log(`Rock #${i}, Calculating...`);
            }
            const rock = ROCKS[i % ROCKS.length];
            let yCoord = height + (i > 0 ? 3 : 2) + rock.length - 1;
            let centerX = 2;
            while (true) {
                windIdx++;
                const windDir = input[windIdx % input.length];

                const coords = getCoords(rock, yCoord, centerX);

                if (
                    windDir === '<' &&
                    centerX > 0 &&
                coords.every(([y, x]) => !map.has(`${y}_${x - 1}`))
                ) {
                    centerX--;
                }
                if (
                    windDir === '>' &&
                    centerX + rock[0].length < 7 &&
                coords.every(([y, x]) => !map.has(`${y}_${x + 1}`))
                ) {
                    centerX++;
                }

                if (getCoords(rock, yCoord, centerX).some(([y, x]) => y - 1 < 0 || map.has(`${y - 1}_${x}`))) {
                    break;
                }

                yCoord--;
            }

            for (let j = 0; j < rock.length; j++) {
                for (let k = 0; k < rock[j].length; k++) {
                    if (rock[j][k] === '#') {
                        if (yCoord - j >= height) {
                            height = yCoord - j + 1;
                        }
                        map.add(`${yCoord - j}_${centerX + k}`);
                    }
                }
            }
        }

        return height;
    }

    console.log('Result:', calculate(MAX_ROCKS));
    // console.log('Result (2 part):', calculate(MAX_ROCKS_PART_2));
}
