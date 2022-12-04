import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(1);

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

