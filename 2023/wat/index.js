import { dirname } from "path";
import { fileURLToPath } from "url";
import { readdirSync, readFileSync } from "fs";
import inquirer from "inquirer";
import { command } from "clap";
import wabt from "wabt";

const directories = readdirSync(dirname(fileURLToPath(import.meta.url)), {
    withFileTypes: true,
})
    .filter((item) => item.isDirectory() && item.name.startsWith("day"))
    .map((item) => ({ name: item.name, value: item.name.replace(/^day/, "") }));

const runDay = (day) => {
    let dayFunc;

    try {
        wabt().then((w) => {
            const wasm = w
                .parseWat(
                    "index.wat",
                    readFileSync(`./day${day}/index.wat`, "utf8")
                )
                .toBinary({
                    log: true,
                    canonicalize_lebs: true,
                    relocatable: false,
                    write_debug_names: false,
                });
            let length = 0;
            const input = readFileSync(`./day${day}/input.txt`, "utf8");
            const inputBuffer = new TextEncoder().encode(input);
            WebAssembly.instantiate(wasm.buffer, {
                env: {
                    log: (num) => console.log("LOG:", num),
                    length: () => length,
                },
            }).then((mod) => {
                const { instance } = mod;
                length = instance.exports.memory.grow(inputBuffer.length);
                new Uint8Array(
                    instance.exports.memory.buffer,
                    length,
                    inputBuffer.length
                ).set(inputBuffer);
                length = inputBuffer.length;

                const result = instance.exports.run();
                const result2 = instance.exports.run2
                    ? instance.exports.run2()
                    : "";

                console.log("Result: ", result, result2);
            });
        });
    } catch (err) {
        console.error("Error: wrong day!");
        process.exit(1);
    }

    // dayFunc.run();
};

const cmd = command("default")
    .option("-d --day <day>", "Run specific day", (value) => Number(value))
    .description("Advent of code solutions")

    .action(({ options }) => {
        if (!options.day) {
            inquirer
                .prompt([
                    {
                        type: "list",
                        name: "day",
                        message: "Choose the day",
                        choices: directories,
                    },
                ])
                .then((answers) => {
                    runDay(answers.day);
                });
        } else {
            runDay(options.day);
        }
    });

cmd.run();
