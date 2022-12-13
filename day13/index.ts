import { getInputLines } from '../utils';

const checkPairs = (pair: any[]) => {
    while (pair[0].length && pair[1].length) {
        const left = pair[0].shift();
        const right = pair[1].shift();

        if (Number.isInteger(left) && Number.isInteger(right)) {
            if (left < right) {
                return true;
            }

            if (left > right) {
                return false;
            }
        }

        if (Number.isInteger(left) && Array.isArray(right)) {
            const res = checkPairs([[left], right]);

            if (typeof res === 'boolean') {
                return res;
            }
        }

        if (Number.isInteger(right) && Array.isArray(left)) {
            const res = checkPairs([left, [right]]);

            if (typeof res === 'boolean') {
                return res;
            }
        }

        if (Array.isArray(left) && Array.isArray(right)) {
            const res = checkPairs([left, right]);

            if (typeof res === 'boolean') {
                return res;
            }
        }
    }

    if (pair[0].length) {
        return false;
    }

    if (pair[1].length) {
        return true;
    }
}

export const run = () => {
    const input = getInputLines(13).filter(item => item);

    const pairs = [];

    for (let i = 0; i < input.length / 2; i++) {
        const item1 = eval(input[i * 2]);
        const item2 = eval(input[i * 2 + 1]);

        pairs.push([item1, item2]);
    }

    const pairsCloned = JSON.parse(JSON.stringify(pairs))
        .reduce((res, [left, right]) => [...res, left, right], []);

    let res = 0;

    for (let i = 0; i < pairs.length; i++) {
        if (checkPairs(pairs[i])) {
            res += i + 1;
        }
    }

    pairsCloned.push([[2]], [[6]]);

    pairsCloned.sort((a, b) =>
        checkPairs([JSON.parse(JSON.stringify(a)), JSON.parse(JSON.stringify(b))]) ? -1 : 1
    );

    const res2 = (pairsCloned.findIndex((item: any[]) => item[0]?.[0] === 2) + 1) *
        (pairsCloned.findIndex((item: any[]) => item[0]?.[0] === 6) + 1);

    console.log('Result:', res);
    console.log('Result (part 2)', res2);
}
