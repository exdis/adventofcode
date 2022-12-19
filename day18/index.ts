import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(18);

    let area = 0;

    const cubes = new Set<string>();

    let minCoord = -Infinity;
    let maxCoord = Infinity;

    for (const line of input) {
        if (!line) continue;

        const [x, y ,z] = line.split(',').map(Number);

        minCoord = Math.min(minCoord, x, y, z);
        maxCoord = Math.max(maxCoord, x, y, z);

        cubes.add(`${x}_${y}_${z}`);
    }

    for (const cube of cubes) {
        const [x, y, z] = cube.split('_').map(Number);
        let sides = 6;

        if (cubes.has(`${x + 1}_${y}_${z}`)) sides--;
        if (cubes.has(`${x - 1}_${y}_${z}`)) sides--;
        if (cubes.has(`${x}_${y + 1}_${z}`)) sides--;
        if (cubes.has(`${x}_${y - 1}_${z}`)) sides--;
        if (cubes.has(`${x}_${y}_${z + 1}`)) sides--;
        if (cubes.has(`${x}_${y}_${z - 1}`)) sides--;

        area += sides;
    }

    console.log('Result:', area);
}
