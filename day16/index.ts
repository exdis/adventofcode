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
                pressure: path.pressure + (path.timeLeft - distances.get(node) - 1) * node.value
            });
        }

        if (!moved && path.pressure > maxPressure) {
            maxPressure = path.pressure;
        }
    }

    console.log('Result:', maxPressure);

    const paths2 = [{
        current1: valveIndex.get('AA').node,
        current2: valveIndex.get('AA').node,
        nextNodes: [...valveIndex.values()].filter(item => item.positive).map(item => item.node),
        timeLeft1: TIME_PART_2,
        timeLeft2: TIME_PART_2,
        pressure: 0
    }];

    let maxPressure2 = 0;

    let n = 0;
    while (paths2.length) {
        const path = paths2.shift();

        const distances1 = distanceMap(path.current1);
        const distances2 = distanceMap(path.current2);

        let moved = false;

        const nextNodes: [TreeNode, TreeNode][] = path.nextNodes.reduce((res, item) => {
            for (const node of path.nextNodes) {
                if (node !== item) {
                    res.push([node, item]);
                }
            }
            return res;
        }, []);

        for (const [node1, node2] of nextNodes) {
            if (node1 === path.current1) continue;
            if (node2 === path.current2) continue;

            if (path.timeLeft1 - distances1.get(node1) <= 1) continue;
            if (path.timeLeft1 - distances2.get(node2) <= 1) continue;

            moved = true;

            paths2.push({
                current1: node1,
                current2: node2,
                nextNodes: path.nextNodes.filter(item => item !== node1 && item !== node2),
                timeLeft1: path.timeLeft1 - distances1.get(node1) - 1,
                timeLeft2: path.timeLeft2 - distances2.get(node2) - 1,
                pressure: path.pressure + ((path.timeLeft1 - distances1.get(node1) - 1) * node1.value) + ((path.timeLeft2 - distances2.get(node2) - 1) * node2.value)
            })
        }

        if (!moved && path.pressure > maxPressure2) {
            console.log('*****', path.pressure);
            maxPressure2 = path.pressure;
        }

        if (n % 10000 === 0) {
            console.log(`${n} path processed, ${paths2.length} paths in total`)
        }
        n++;
    }

    console.log('Result:', maxPressure2);
}
