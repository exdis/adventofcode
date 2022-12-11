import { getInputLines } from '../utils';

class Monkey {
    private inspectionsCount: number;

    constructor(
        private items: number[],
        private operation: string,
        private test: number,
        private ifTrue: number,
        private ifFalse: number,
    ) {
        this.inspectionsCount = 0;
    }

    hasItems(): boolean {
        return !!this.items.length;
    }

    getInspectionsCount() {
        return this.inspectionsCount;
    }

    catch(item: number) {
        this.items.push(item);
    }

    throwItem() {
        const item = this.items.shift();
        return item;
    }

    testItem(): [number, number] {
        if (this.items[0]) {
            const test = this.items[0] % this.test === 0;

            return [this.throwItem(), test ? this.ifTrue : this.ifFalse];
        }
    }

    operate(divideBy3: boolean = true, supermodulo = 1) {
        if (this.items[0]) {
            let item = this.items.shift();
            item = supermodulo > 1 ? item % supermodulo : item;
            const operation = this.operation.replace(/old/g, item.toString());
            let newItem = parseInt(eval(operation), 10);
            if (divideBy3) {
                newItem = Math.floor(newItem / 3);
            }
            this.items.unshift(newItem);
            this.inspectionsCount++;
        }
    }
}

export const run = () => {
    const input = getInputLines(11).filter(item => item);

    const monkeys: Monkey[] = [];
    const monkeys2part: Monkey[] = [];

    let supermodulo = 1;

    for (let i = 0; i < input.length / 5; i++) {
        const monkey = i * 6;
        if (input[monkey + 1]) {
            const items = input[monkey + 1].match(/Starting items: (.*)/)[1].split(', ').map(Number);
            const operation = input[monkey + 2].match(/Operation: new = (.*)/)[1];
            const test = parseInt(input[monkey + 3].match(/Test: divisible by (\d+)/)[1], 10);
            const ifTrue = parseInt(input[monkey + 4].match(/If true: throw to monkey (\d+)/)[1], 10);
            const ifFalse = parseInt(input[monkey + 5].match(/If false: throw to monkey (\d+)/)[1], 10);

            monkeys.push(new Monkey(items.slice(), operation, test, ifTrue, ifFalse));
            monkeys2part.push(new Monkey(items.slice(), operation, test, ifTrue, ifFalse));

            supermodulo *= test;
        }
    }

    for (let i = 0; i < 20; i++) {
        for (const monkey of monkeys) {
            while(monkey.hasItems()) {
                monkey.operate();
                const [item, monkeyIdx] = monkey.testItem();
                monkeys[monkeyIdx].catch(item);
            }
        }
    }

    let inspectionsCount = monkeys.map(monkey => monkey.getInspectionsCount()).sort((a, b) => b - a);
    console.log('Result:', inspectionsCount[0] * inspectionsCount[1]);

    for (let i = 0; i < 10000; i++) {
        for (const monkey of monkeys2part) {
            while(monkey.hasItems()) {
                monkey.operate(false, supermodulo);
                const [item, monkeyIdx] = monkey.testItem();
                monkeys2part[monkeyIdx].catch(item);
            }
        }
    }

    inspectionsCount = monkeys2part.map(monkey => monkey.getInspectionsCount()).sort((a, b) => b - a);
    console.log('Result part 2:', inspectionsCount[0] * inspectionsCount[1]);
}
