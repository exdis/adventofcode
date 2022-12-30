import { getInputLines } from '../utils';

class TreeNode {
    constructor(
        public value: number,
        public name: string,
        public children: TreeNode[]
    ) {}
}

const TIME = 30;
const TIME_PART_2 = 26;

export const run = () => {
    const input = getInputLines(16);

    const valveIndex = new Map<string, { node: TreeNode, valves: string[], positive: boolean }>();

    const distanceMap = (node: TreeNode) => {
        const distances: Map<TreeNode, number> = new Map();

        const lookup = (item: TreeNode, steps: number) => {
            if (distances.has(item) && distances.get(item) <= steps) return;

            if (steps > 0) {
                distances.set(item, steps);
            }

            item.children.map(child => lookup(child, steps + 1))
        }

        lookup(node, 0);

        return distances;
    }

    for (const line of input) {
        if (!line) continue;

        const [, name, flow, names] = line.match(/^Valve (.*) has flow rate=(\d+); tunnels? leads? to valves? (.*)/);

        const valves = names.split(', ');

        const flowNum = parseInt(flow, 10);

        valveIndex.set(name, { node: new TreeNode(flowNum, name, []), valves, positive: flowNum > 0 });
    }

    let tree: TreeNode | null = null;

    for (const data of valveIndex.values()) {
        const { node, valves } = data;

        node.children = valves.map(name => valveIndex.get(name).node);

        if (!tree) {
            tree = node;
        }
    }

    const paths = [{
        current: valveIndex.get('AA').node,
        nextNodes: [...valveIndex.values()].filter(item => item.positive).map(item => item.node),
        timeLeft: TIME,
        steps: [],
        pressure: 0
    }];

    let maxPressure = 0;

    while (paths.length) {
        const path = paths.shift();

        const distances = distanceMap(path.current);

        let moved = false;

        for (const node of path.nextNodes) {
            if (node === path.current) continue;
            if (path.timeLeft - distances.get(node) <= 1) continue;

            moved = true;

            paths.push({
                current: node,
                nextNodes: path.nextNodes.filter(item => item !== node),
                timeLeft: path.timeLeft - distances.get(node) - 1,
                steps: [...path.steps, node],
                pressure: path.pressure + (path.timeLeft - distances.get(node) - 1) * node.value
            });
        }

        if (!moved && path.pressure > maxPressure) {
            maxPressure = path.pressure;
        }
    }

    console.log('Result:', maxPressure);
}
