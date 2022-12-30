import { getInputLines } from '../utils';

class TreeNode {
    name: string;
    type: 'dir' | 'file';
    size: number | null;
    children: TreeNode[];
    parent: TreeNode | null;

    constructor(
        name: string,
        type: 'dir' | 'file',
        size: number | null,
        children: TreeNode[],
        parent: TreeNode
    ) {
        this.name = name;
        this.type = type;
        this.size = size;
        this.children = children;
        this.parent = parent;
    }
}

let sumSize = 0;
const dirSizes = [];

const countTotalSize = (tree: TreeNode) => {
    let sum = 0;
    for (const child of tree.children) {
        if (child.type === 'file') {
            sum += child.size;
        } else {
            const dirSize = countTotalSize(child);
            child.size = dirSize;
            sum += dirSize;
            dirSizes.push(dirSize);
            if (dirSize <= 100000) {
                sumSize += dirSize
            }
        }
    }

    return sum;
}

export const run = () => {
    const input = getInputLines(7);

    const tree = new TreeNode('/', 'dir', null, [], null);
    let currentNode: TreeNode;

    for (const line of input) {
        if (!line) continue;

        if (line === '$ cd /') {
            currentNode = tree;
            continue;
        }

        if (line === '$ ls') continue;

        if (line.match(/^\$ cd (.*)/)) {
            const dirToChange = line.replace('$ cd ', '');

            if (dirToChange === '..') {
                currentNode = currentNode.parent;
            } else {
                for (const child of currentNode.children) {
                    if (child.name === dirToChange) {
                        currentNode = child;
                        break;
                    }
                }
            }

            continue;
        }

        const [typeSize, name] = line.split(' ');

        const type = typeSize === 'dir' ? 'dir' : 'file';
        const size = type !== 'dir' ? parseInt(typeSize, 10) : null;

        currentNode.children.push(new TreeNode(name, type, size, [], currentNode));
    }

    tree.size = countTotalSize(tree);

    dirSizes.push(tree.size);
    dirSizes.sort((a, b) => a - b);

    let dirToDelete = 0;

    const spaceToFree = 30000000 - (70000000 - tree.size);

    for (let i = 0; i < dirSizes.length; i++) {
        const dirSize = dirSizes[i];
        if (dirSize >= spaceToFree) {
            dirToDelete = dirSize;
            break;
        }
    }

    console.log('Sum size:', sumSize);
    console.log('Dir size to delete:', dirToDelete);
}
