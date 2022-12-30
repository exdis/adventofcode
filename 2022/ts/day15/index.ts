import { getInputLines } from '../utils';

enum Item {
    Sensor,
    Beacon,
    NoBeacon
}

type Sensor = {
    x: number;
    y: number;
    range: number;
}

const TARGET_LINE = 2000000;
const MAX_COORD = 4000000;

export const run = () => {
    const input = getInputLines(15);

    const map = new Map<string, Item>();
    const sensors: Sensor[] = [];

    for (const line of input) {
        if (!line) continue;
        let [sensorX, sensorY, beaconX, beaconY] =
            line
                .match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)
                .slice(1, 5)
                .map(Number);

        map.set(`${sensorX}_${sensorY}`, Item.Sensor);
        map.set(`${beaconX}_${beaconY}`, Item.Beacon);

        const range = Math.abs(sensorX - beaconX) + Math.abs(sensorY - beaconY);

        sensors.push({
            x: sensorX,
            y: sensorY,
            range
        });
    }

    for (const sensor of sensors) {
        const { range, x, y } = sensor;

        const yDiff = Math.abs(TARGET_LINE - y);
        const diff = range - yDiff;

        for (let i = x; i <= x + diff; i++) {
            if (!map.get(`${i}_${TARGET_LINE}`)) {
                map.set(`${i}_${TARGET_LINE}`, Item.NoBeacon);
            }
        }
        for (let i = x; i >= x - diff; i--) {
            if (!map.get(`${i}_${TARGET_LINE}`)) {
                map.set(`${i}_${TARGET_LINE}`, Item.NoBeacon);
            }
        }
    }

    const forbiddenCells = [...map.entries()]
        .filter(([key, value]) => value === Item.NoBeacon && key.split('_')[1] === TARGET_LINE.toString());

    console.log('Result:', forbiddenCells.length);

    let secondRes: [number, number];

    for (let row = 0; row <= MAX_COORD; row++) {
        const intervals = [];
        for (const sensor of sensors) {
            const { range, x, y } = sensor;

            const yDiff = Math.abs(row - y);
            const diff = range - yDiff;

            if (diff < 0) continue;

            const startX = x - diff;
            const endX = x + diff;

            intervals.push([startX, endX]);
        }

        if (intervals.length < 2) return intervals;

        intervals.sort((a, b) => a[0] - b[0]);

        const merged = [];
        let previous = intervals[0];

        for (let i = 1; i < intervals.length; i += 1) {
            if (previous[1] >= intervals[i][0] - 1) {
                previous = [previous[0], Math.max(previous[1], intervals[i][1])];
            } else {
                merged.push(previous);
                previous = intervals[i];
            }
        }

        merged.push(previous);

        if (merged.length > 1) {
            secondRes = [merged[0][1] + 1, row];
        } else {
            if (merged[0][0] - 1 > 0) {
                secondRes = [merged[0][0] - 1, row];
                break;
            }
            if (merged[0][merged[0].length - 1] - 1 < MAX_COORD) {
                secondRes = [merged[0][merged.length - 1] - 1, row];
                break;
            }
        }
    }

    console.log('Result (2 part):', secondRes[0] * 4000000 + secondRes[1]);
}
