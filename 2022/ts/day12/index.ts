import { start } from 'repl';
import { getInputLines } from '../utils';

const A_CODE = 'a'.charCodeAt(0);

type Point = { x: number, y: number };

export const run = () => {
    const input = getInputLines(12);
    const map = input.map(line => line.split(''));

    let startPoint: Point = { x: 0, y: 0 };
    let endPoint: Point = { x: 0, y: 0 };

    for (let i = 0; i < map.length; i++) {
        for (let j = 0; j < map[i].length; j++) {
            if (map[i][j] === 'S') {
                startPoint = { x: i, y: j };
                map[i][j] = 'a';
            }
            if (map[i][j] === 'E') {
                endPoint = { x: i, y: j };
                map[i][j] = 'z';
            }
        }
    }

    const solve = (startPoint: Point) => {
        const queue = [[startPoint]];

        let minPath = Infinity;

        const visited = new Set<string>();

        const addToQueue = (path: Point[], x: number, y: number) => {
            if (map[x] && map[x][y]) {
                let destCharCode = map[x][y].charCodeAt(0);
                const lastPoint = path[path.length - 1];
                let currCharCode = map[lastPoint.x][lastPoint.y].charCodeAt(0);

                const diff = destCharCode - currCharCode;

                if (diff <= 1 && !visited.has(`${x}_${y}`)) {
                    visited.add(`${x}_${y}`);
                    queue.push(path.concat({ x, y }))
                }
            }
        }

        while (queue.length) {
            const path = queue.shift();

            const { x, y } = path[path.length - 1];

            if (endPoint.x === x && endPoint.y === y) {
                if (path.length - 1 < minPath) {
                    minPath = path.length - 1;
                }
                continue
            }

            // top
            addToQueue(path, x - 1, y);
            // bottom
            addToQueue(path, x + 1, y);
            // left
            addToQueue(path, x, y - 1);
            // right
            addToQueue(path, x, y + 1);
        }

        return minPath;
    }

    console.log('Min path:', solve(startPoint));

    let minAPath = Infinity;

    for (let i = 0; i < map.length; i++) {
        for (let j = 0; j < map.length; j++) {
            if (map[i][j] === 'a') {
                const minPath = solve({ x: i, y: j });
                if (minPath < minAPath) {
                    minAPath = minPath;
                }
            }
        }
    }

    console.log('Min path (2 part):', minAPath);
}
