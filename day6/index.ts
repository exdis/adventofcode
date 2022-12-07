import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(6)[0];

    let map = new Map<string, boolean>();
    let mapPartTwo = new Map<string, boolean>();

    let result = 0;
    let resultPartTwo = 0;

    for (let i = 0; i < input.length; i++) {
        const char = input[i];

        if (map.has(char)) {
            map = new Map<string, boolean>();
        }

        if (mapPartTwo.has(char)) {
            mapPartTwo = new Map<string, boolean>();
        }

        map.set(char, true);
        mapPartTwo.set(char, true);

        if (map.size === 4 && result === 0) {
            result = i + 1;
        }

        if (mapPartTwo.size === 14 && resultPartTwo === 0) {
            resultPartTwo = i + 1;
        }
    }

    console.log('Result:', result);
    console.log('Result part 2 :', resultPartTwo);
}
