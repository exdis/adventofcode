import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(1);

    let max = 0;
    let sum = 0;

    const calories = [];

    for (const item of input) {
        if (item !== '') {
            sum += parseInt(item, 10);
        } else {
            if (sum > max) {
                max = sum;
            }
            calories.push(sum);
            sum = 0;
        }
    }

    calories.sort((a, b) => b - a);

    console.log('max:', max);
    console.log('top 3:', calories[0] + calories[1] + calories[2]);
}

