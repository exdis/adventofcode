import { getInputLines } from '../utils';

const getItemPriority = (item: string) => {
    if (item === item.toUpperCase()) {
        return item.codePointAt(0) - 38;
    } else {
        return item.codePointAt(0) - 96;
    }
}

export const run = () => {
    const input = getInputLines(3);

    let sum = 0;
    let groupSum = 0;
    let cnt = 0;
    let sets: Set<string>[] = Array(3);
    let intersection: string[] = [];

    for (const rucksack of input) {
        if (!rucksack) continue;

        const firstCompartment = {};
        const items = new Set<string>();

        for (let i = 0; i < rucksack.length; i++) {
            const item = rucksack[i];

            sets[cnt] = sets[cnt] || new Set<string>();
            sets[cnt].add(item);

            if (i < rucksack.length / 2) {
                firstCompartment[item] = true;
            } else {
                if (firstCompartment[item]) {
                    items.add(item);
                }
            }
        }

        if (cnt === 2) {
            for (const item of sets[0].values()) {
                if (sets[1].has(item) && sets[2].has(item)) {
                    intersection.push(item);
                }
            }
            sets.length = 0;
            cnt = 0;

        } else {
            cnt++;
        }

        for (const item of items.values()) {
            sum += getItemPriority(item);
        }
    }

    for (const item of intersection.values()) {
        groupSum += getItemPriority(item);
    }

    console.log('sum:', sum);
    console.log('group sum:', groupSum);
}
