import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus, BadRequestException, ParseUUIDPipe } from '@nestjs/common';
import { TaskService } from './task.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { GetTaskDTO } from './dto/get-task.dto';
import { Task } from './entities/task.entity';
import { plainToInstance } from 'class-transformer';

@Controller('api')
export class TaskController {
  constructor(private readonly taskService: TaskService) { }

  @Get("tasks")
  async getAlltasks(): Promise<GetTaskDTO[]> {
    return await this.taskService.getAllTasks();
  }

  @Get("task/:id")
  async getTask(@Param("id") id: string): Promise<GetTaskDTO | null> {
    return plainToInstance(GetTaskDTO, await this.taskService.getTask(id))
  }

  @Post("tasks")
  async createTask(@Body() taskBody: CreateTaskDto): Promise<Task> {
    return await this.taskService.createTask(taskBody)
  }

  @Delete("tasks/:id")
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteTask(@Param("id", ParseUUIDPipe) id: string): Promise<void> {
    return await this.taskService.deleteTask(id)
  }

  @Patch("tasks/:id")
  async patchTask(@Param("id", ParseUUIDPipe) id: string, @Body() dto: UpdateTaskDto): Promise<Task| undefined> {
    return await this.taskService.patchTask(id, dto);
  }

}