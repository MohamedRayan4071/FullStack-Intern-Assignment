import { registerAs } from "@nestjs/config";
import { TypeOrmModuleOptions } from "@nestjs/typeorm";
import { config } from "dotenv"
import { Task } from "src/task/entities/task.entity";
import { TaskHistory } from "src/task/entities/task_history.entity";

config({
    path: 'src/.env',
    override: true,
});

export const dbConfig = registerAs("db", (): TypeOrmModuleOptions => {
    return {
        port:5432,
        database: process.env.DATABASE,
        host: process.env.HOST,
        username: process.env.USER,
        password: process.env.PASSWORD,
        type: "postgres",
        entities: [Task, TaskHistory],
        ssl: {
            rejectUnauthorized: false
        }
    }
})
