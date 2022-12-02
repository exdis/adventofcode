import path from 'path';
import fs from 'fs';

export const run = () => {
    const input = fs.readFileSync(path.join(__dirname, 'input.txt'))
        .toString()
        .split('\n');

    let max = 0;
    let sum = 0;

    for (const item of input) {
        if (item !== '') {
            sum += parseInt(item, 10);
        } else {
            if (sum > max) {
                max = sum;
            }
            sum = 0;
        }
    }

    console.log('max:', max);
}

