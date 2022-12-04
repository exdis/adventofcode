import path from 'path';
import fs from 'fs';

export const run = () => {
    const input = fs.readFileSync(path.join(__dirname, 'input.txt'))
        .toString()
        .split('\n');

    let overlaps = 0;

    for (const item of input) {
        if (!item) continue;

        const [first,second] = item.split(',');
        const [firstStart, firstEnd] = first.split('-').map(Number);
        const [secondStart, secondEnd] = second.split('-').map(Number);

        if (
            (firstStart >= secondStart && firstEnd <= secondEnd) ||
            (secondStart >= firstStart && secondEnd <= firstEnd)
        ) {
            overlaps++;
        }
    }

    console.log('num:', overlaps);
}
