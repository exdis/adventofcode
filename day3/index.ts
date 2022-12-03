import path from 'path';
import fs from 'fs';

const getItemPriority = (item: string) => {
    if (item === item.toUpperCase()) {
        return item.codePointAt(0) - 38;
    } else {
        return item.codePointAt(0) - 96;
    }
}

export const run = () => {
    const input = fs.readFileSync(path.join(__dirname, 'input.txt'))
        .toString()
        .split('\n');

    let sum = 0;

    for (const rucksack of input) {
        if (!rucksack) continue;

        const firstCompartment = {};
        const items = new Set<string>();

        for (let i = 0; i < rucksack.length; i++) {
            const item = rucksack[i];

            if (i < rucksack.length / 2) {
                firstCompartment[item] = true;
            } else {
                if (firstCompartment[item]) {
                    items.add(item);
                }
            }
        }
        for (const item of items.values()) {
            sum += getItemPriority(item);
        }
    }

    console.log('sum:', sum);
}
