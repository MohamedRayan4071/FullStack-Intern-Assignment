import { Module } from '@nestjs/common';
import { TaskService } from './task.service';
import { TaskController } from './task.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Task } from './entities/task.entity';
import { TaskHistory } from './entities/task_history.entity';
import { TaskUtilities } from './task.provider';

@Module({
  imports: [TypeOrmModule.forFeature([Task, TaskHistory])],
  controllers: [TaskController],
  providers: [TaskService, TaskUtilities],
})
export class TaskModule { }
