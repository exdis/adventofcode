import path from 'path';
import fs from 'fs';

export const getInputLines = (day: number): string[] => {
    return fs.readFileSync(path.join(__dirname, `day${day}`, 'input.txt'))
        .toString()
        .split('\n');
}
