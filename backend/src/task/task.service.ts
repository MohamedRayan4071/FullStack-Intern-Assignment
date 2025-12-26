import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Task } from './entities/task.entity';
import { DeepPartial, Repository } from 'typeorm';
import { TaskHistory } from './entities/task_history.entity';
import { GetTaskDTO } from './dto/get-task.dto';
import { plainToInstance } from 'class-transformer';
import { TaskUtilities } from './task.provider';
import { Entity } from './predefined/entity.interface';
import { CategoryKey } from './predefined/category.type';

@Injectable()
export class TaskService {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepository: Repository<Task>,
    @InjectRepository(TaskHistory)
    private readonly taskHistoryRepository: Repository<TaskHistory>,
    @Inject(TaskUtilities)
    private readonly taskUtilities: TaskUtilities,
  ) { }

  async getAllTasks(category: string | undefined, priority: string | undefined, limit = 10, offset = 0): Promise<GetTaskDTO[]> {
    const qb = this.taskRepository
      .createQueryBuilder('task')
      .leftJoinAndSelect('task.taskHistory', 'history')
      .orderBy('task.created_at', 'DESC')
      .limit(limit)
      .offset(offset);

    if (category && priority) {
      qb.where('task.category = :category', { category })
        .andWhere('task.priority = :priority', { priority });
    } else if (category) {
      qb.where('task.category = :category', { category });
    } else if (priority) {
      qb.where('task.priority = :priority', { priority });
    }

    const tasks = await qb.getMany()

    return tasks.map((t) => plainToInstance(GetTaskDTO, t));
  }

  async getTask(id: string): Promise<Task | null> {
    return this.taskRepository.findOne({ where: { id }, relations: ['taskHistory'] });
  }

  async createTask(createTaskData: CreateTaskDto): Promise<Task> {
    const text = `${createTaskData.title ?? ''} ${createTaskData.description ?? ''
      }`.trim();

    const category = this.taskUtilities.extractCategory(text);
    const priority = this.taskUtilities.extractPriority(text);
    const assigned_to = this.taskUtilities.extractAssignedPerson(text);
    const due_date = this.taskUtilities.extractDueDate(text);
    const suggested_actions = this.taskUtilities.getSuggestedActions(category as CategoryKey);

    const entity: Entity = {
      dates: this.taskUtilities.extractDates(text),
      people: assigned_to ? [assigned_to] : [],
      locations: this.taskUtilities.extractLocations(text),
      actions: this.taskUtilities.extractActions(text),
    };

    const task = this.taskRepository.create({
      ...createTaskData,
      id: this.taskUtilities.generateUUID(),
      category,
      priority,
      assigned_to,
      due_date,
      status: 'pending',
      extracted_entities: entity,
      suggested_actions,
      created_at: new Date(),
    } as DeepPartial<Task>);

    return await this.taskRepository.save(task);
  }

  async patchTask(id: string, dto: any): Promise<Task> {
    const oldTask = await this.taskRepository.findOne({ where: { id } });
    if (!oldTask) throw new NotFoundException('Task not found');

    const text = `${dto.title ?? oldTask.title} ${dto.description ?? oldTask.description
      }`.trim();

    if (dto.title || dto.description) {
      dto.category = this.taskUtilities.extractCategory(text);
      dto.priority = this.taskUtilities.extractPriority(text);
      dto.assigned_to =
        dto.assigned_to || this.taskUtilities.extractAssignedPerson(text);
      dto.due_date = this.taskUtilities.extractDueDate(text);
      dto.suggested_actions = this.taskUtilities.getSuggestedActions(dto.category);
    }

    const entity: Entity = {
      dates: this.taskUtilities.extractDates(text),
      people: dto.assigned_to ? [dto.assigned_to] : [],
      locations: this.taskUtilities.extractLocations(text),
      actions: this.taskUtilities.extractActions(text),
    };

    const task = await this.taskRepository.preload({
      id,
      ...dto,
      extracted_entities: entity,
      updated_at: new Date(),
    });

    if (!task) throw new NotFoundException('Failed to preload task');

    await this.taskRepository.save(task);

    const taskHistory = this.taskHistoryRepository.create({
      id: this.taskUtilities.generateUUID(),
      action: 'updated',
      changed_by: 'user',
      task,
      changed_at: new Date(),
      old_value: oldTask,
      new_value: dto,
    });

    await this.taskHistoryRepository.save(taskHistory);

    return task;
  }

  async deleteTask(id: string): Promise<void> {
    await this.taskRepository.delete(id);
  }
}
