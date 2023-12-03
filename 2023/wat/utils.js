import { join, dirname } from "path";
import { fileURLToPath } from "url";
import { readFileSync } from "fs";

const getInputLines = (day) => {
    return readFileSync(
        join(dirname(fileURLToPath(import.meta.url)), `day${day}`, "input.txt")
    )
        .toString()
        .split("\n");
};

module.exports = {
    getInputLines,
};
