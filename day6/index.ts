import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(6)[0];

    let map = new Map<string, boolean>();

    let result = 0;

    for (let i = 0; i < input.length; i++) {
        const char = input[i];

        if (map.has(char)) {
            map = new Map<string, boolean>();
        }

        map.set(char, true);

        if (map.size === 4) {
            result = i + 1;
            break;
        }
    }

    console.log('Result:', result);
}
