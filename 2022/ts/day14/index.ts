import { getInputLines } from '../utils';

enum Item {
    FallingSand,
    RestingSand,
    Rock
}

export const run = () => {
    const input = getInputLines(14);

    let map = new Map<string, Item>();

    for (let i = 0; i < input.length; i++) {
        const line = input[i];

        if (!line) continue;

        const coords = line.split(' -> ').map(item => item.split(',').map(Number));

        for (let i = 0; i < coords.length - 1; i++) {
            const [x, y] = coords[i];
            const [nextX, nextY] = coords[i + 1];

            for (let j = 0; j < Math.abs(x - nextX) + 1; j++) {
                const newX = x + (x > nextX ? -1 : 1) * j;
                map.set(`${newX}_${y}`, Item.Rock);
            }
            for (let j = 0; j < Math.abs(y - nextY) + 1; j++) {
                const newY = y + (y > nextY ? -1 : 1) * j;
                map.set(`${x}_${newY}`, Item.Rock);
            }
        }
    }

    let sandUnits = 0;
    let fallingSand: string | null = null;
    let lastRockY = [...map.keys()]
        .map(item => Number(item.replace(/^.*_/, '')))
        .sort((a, b) => b - a)[0];

    while (map.get('500_0') !== Item.RestingSand) {
        if (!fallingSand) {
            sandUnits++;
            fallingSand = '500_0';
            map.set('500_0', Item.FallingSand);
            continue;
        }

        const [x, y] = fallingSand.split('_').map(Number);

        if (y >= lastRockY) { sandUnits--; break; }

        map.delete(fallingSand);

        const unitBelow = map.get(`${x}_${y + 1}`);

        // Free fall
        if (!unitBelow) {
            fallingSand = `${x}_${y + 1}`;
            map.set(fallingSand, Item.FallingSand);
            continue;
        }

        // Sand below
        if (unitBelow === Item.RestingSand || unitBelow === Item.Rock) {
            const unitLeft = map.get(`${x - 1}_${y + 1}`);
            const unitRight = map.get(`${x + 1}_${y + 1}`);

            // Left and Right
            if (unitLeft && unitRight) {
                fallingSand = null;
                map.set(`${x}_${y}`, Item.RestingSand);
                continue;
            }
            // Empty left
            if (!unitLeft) {
                fallingSand = `${x - 1}_${y + 1}`;
                map.set(fallingSand, Item.FallingSand);
                continue;
            }
            // Occupied left and empty right
            if (!unitRight) {
                fallingSand = `${x + 1}_${y + 1}`;
                map.set(fallingSand, Item.RestingSand);
                continue;
            }
        }
    }

    console.log('Result:', sandUnits);

    // Erasing map
    for (const [key, value] of map) {
        if (value !== Item.Rock) {
            map.delete(key);
        }
    }

    sandUnits = 0;
    fallingSand = null;

    while (map.get('500_0') !== Item.RestingSand) {
        if (!fallingSand) {
            sandUnits++;
            fallingSand = '500_0';
            map.set('500_0', Item.FallingSand);
            continue;
        }

        const [x, y] = fallingSand.split('_').map(Number);

        map.delete(fallingSand);

        let unitBelow = map.get(`${x}_${y + 1}`);
        if (y + 1 === lastRockY + 2) unitBelow = Item.Rock;

        // Free fall
        if (!unitBelow) {
            fallingSand = `${x}_${y + 1}`;
            map.set(fallingSand, Item.FallingSand);
            continue;
        }

        // Sand below
        if (unitBelow === Item.RestingSand || unitBelow === Item.Rock) {
            let unitLeft = map.get(`${x - 1}_${y + 1}`);
            if (y + 1 === lastRockY + 2) unitLeft = Item.Rock;
            let unitRight = map.get(`${x + 1}_${y + 1}`);
            if (y + 1 === lastRockY + 2) unitRight = Item.Rock;

            // Left and Right
            if (unitLeft && unitRight) {
                fallingSand = null;
                map.set(`${x}_${y}`, Item.RestingSand);
                continue;
            }
            // Empty left
            if (!unitLeft) {
                fallingSand = `${x - 1}_${y + 1}`;
                map.set(fallingSand, Item.FallingSand);
                continue;
            }
            // Occupied left and empty right
            if (!unitRight) {
                fallingSand = `${x + 1}_${y + 1}`;
                map.set(fallingSand, Item.RestingSand);
                continue;
            }
        }
    }

    console.log('Result (2 part):', sandUnits)
}
