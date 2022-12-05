import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(5);

    const idx = input.findIndex(item => item === '');
    const moveInstructions = input.slice(idx);

    const stacks = [];

    for (let i = 0; i < idx - 1; i++) {
        const item = input[i];
        for (let j = 0; j < item.length / 4; j++) {
            const itemStr = item.slice(4 * j, 4 * j + 4).match(/[A-Z]/);

            const itemLetter = itemStr ? itemStr[0] : null;

            if (itemLetter) {
                stacks[j] = stacks[j] || [];
                stacks[j].unshift(itemLetter);
            }
        }
    }

    for (let i = 0; i < moveInstructions.length; i++) {
        const instruction = moveInstructions[i];

        if (!instruction) continue;

        const [, qty, from, to] = instruction.match(/move (\d+) from (\d+) to (\d+)/);

        for (let j = 0; j < parseInt(qty, 10); j++) {
            const item = stacks[parseInt(from, 10) - 1].pop();
            stacks[parseInt(to, 10) - 1].push(item);
        }
    }

    let res = '';

    for (let i = 0; i < stacks.length; i++) {
        res += stacks[i][stacks[i].length - 1];
    }

    console.log('Result:', res);
}
