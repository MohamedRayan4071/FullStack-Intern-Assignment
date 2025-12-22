import { Inject, Injectable } from '@nestjs/common';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Task } from './entities/task.entity';
import { Repository } from 'typeorm';
import { TaskHistory } from './entities/task_history.entity';
import { GetTaskDTO } from './dto/get-task.dto';
import { plainToInstance } from 'class-transformer';
import { TaskUtilities } from './task.provider';

@Injectable()
export class TaskService {
  constructor(
    @InjectRepository(Task) private readonly taskRepository: Repository<Task>,
    @InjectRepository(TaskHistory) private readonly taskHistoryRepository: Repository<TaskHistory>,
    @Inject(TaskUtilities) private readonly taskUtilities: TaskUtilities
  ) { }

  async getAllTasks(
    limit = 10,
    offset = 0
  ): Promise<GetTaskDTO[]> {
    const query = this.taskRepository.createQueryBuilder('task');

    query.limit(limit).offset(offset).orderBy('task.created_at', 'DESC');

    return (await query.getMany()).map(task => plainToInstance(GetTaskDTO, task));
  }

  async getTask(id: string): Promise<Task | null> {
    return await this.taskRepository.findOne({ where: { id } })
  }

  async createTask(createTaskData: CreateTaskDto): Promise<Task> {
   const task = this.taskRepository.create(createTaskData)

   const id: string = this.taskUtilities.generateUUID()

   task.id = id

   return this.taskRepository.save(task)
  }

  async deleteTask(id: string): Promise<void>{
    await this.taskRepository.delete(id)
  }
}
