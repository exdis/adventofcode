import { readdirSync } from 'fs'
import inquirer from 'inquirer';

const directories = readdirSync(__dirname, { withFileTypes: true })
    .filter(item => item.isDirectory() && item.name.startsWith('day'))
    .map(item => item.name);

inquirer
    .prompt([
        {
            type: 'list',
            name: 'day',
            message: 'Choose the day',
            choices: directories
        }
    ])
    .then(answers => {
        require(`./${answers.day}`).run();
    })
