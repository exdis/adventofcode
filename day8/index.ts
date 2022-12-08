import { getInputLines } from '../utils';

export const run = () => {
    const input = getInputLines(8);

    const field: number[][] = [];

    let visible = 0;
    let maxScenicScore = 0;

    for (let i = 0; i < input.length; i++) {
        const line = input[i];

        if (!line) continue;

        field[i] = line.split('').map(Number);
    }

    for (let i = 0; i < field.length; i++) {
        for (let j = 0; j < field[i].length; j++) {
            const tree = field[i][j];

            // top
            let k = i - 1;
            let topVisible = true;
            let topScenicScore = 0;
            while (k >= 0) {
                if (topVisible) {
                    topScenicScore++;
                }
                if (field[k][j] >= tree) {
                    topVisible = false;
                }
                k--;
            }

            // bottom
            k = i + 1;
            let bottomVisible = true;
            let bottomScenicScore = 0;
            while (k <= field.length - 1) {
                if (bottomVisible) {
                    bottomScenicScore++;
                }
                if (field[k][j] >= tree) {
                    bottomVisible = false;
                }
                k++;
            }

            // left
            k = j - 1;
            let leftVisible = true;
            let leftScenicScore = 0;
            while (k >= 0) {
                if (leftVisible) {
                    leftScenicScore++;
                }
                if (field[i][k] >= tree) {
                    leftVisible = false;
                    break;
                }
                k--;
            }

            // right
            k = j + 1;
            let rightVisible = true;
            let rightScenicScore = 0;
            while (k <= field[i].length - 1) {
                if (rightVisible) {
                    rightScenicScore++;
                }
                if (field[i][k] >= tree) {
                    rightVisible = false;
                    break;
                }
                k++;
            }

            const scenicScore = topScenicScore * bottomScenicScore * leftScenicScore * rightScenicScore;

            if (scenicScore > maxScenicScore) {
                maxScenicScore = scenicScore;
            }

            if (topVisible || bottomVisible || leftVisible || rightVisible) {
                visible++;
            }
        }
    }

    console.log('Result:', visible);
    console.log('Max scenic score:', maxScenicScore);
}
