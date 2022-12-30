import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(10);

    let x = 1;
    let cycles = 1;

    const queue = input.filter(item => item).reverse();

    let localCycles = 0;

    let strengthSum = 0;

    const pixels = [];
    for (let i = 0; i < 6; i++) {
        pixels[i] = '.'.repeat(40).split('');
    }
    const sprite = '.'.repeat(40).split('');
    sprite[0] = '#';
    sprite[1] = '#';
    sprite[2] = '#';

    while(queue.length) {
        if (
            cycles === 20 ||
            cycles === 60 ||
            cycles === 100 ||
            cycles === 140 ||
            cycles === 180 ||
            cycles === 220
        ) {
            strengthSum += cycles * x;
            console.log(`${cycles}th cycle, X: ${x}, strength: ${cycles * x}`)
        }

        const command = queue.pop();

        const line = Math.floor((cycles - 1) / 40);
        const pixel = cycles - 1 - line * 40;
        if (pixels[line] && pixels[line][pixel] && sprite[pixel] === '#') {
            pixels[line][pixel] = '#';
        }

        if (command === 'noop') {
            cycles++;
            continue;
        }

        if (localCycles === 0) {
            queue.push(command);
            localCycles++;
            cycles++;
            continue;
        }

        if (localCycles === 1) {
            localCycles = 0;
            const amt = parseInt(command.replace(/^addx /, ''), 10);
            x += amt;
            sprite.fill('.');
            sprite[x] = '#';
            if (sprite[x - 1]) {
                sprite[x - 1] = '#';
            }
            if (sprite[x + 1]) {
                sprite[x + 1] = '#';
            }
            cycles++;
        }
    }

    console.log('Strength sum', strengthSum);

    for (const line of pixels) {
        console.log(line.join(''));
    }
}
