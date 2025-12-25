"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dbConfig = void 0;
const config_1 = require("@nestjs/config");
const dotenv_1 = require("dotenv");
const task_entity_1 = require("../task/entities/task.entity");
const task_history_entity_1 = require("../task/entities/task_history.entity");
(0, dotenv_1.config)({
    path: 'src/.env',
    override: true,
});
exports.dbConfig = (0, config_1.registerAs)("db", () => {
    return {
        port: 5432,
        database: process.env.DATABASE,
        host: process.env.HOST,
        username: process.env.USER,
        password: process.env.PASSWORD,
        type: "postgres",
        entities: [task_entity_1.Task, task_history_entity_1.TaskHistory],
        ssl: {
            rejectUnauthorized: false
        }
    };
});
