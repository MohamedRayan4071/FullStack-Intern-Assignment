import { PartialType } from '@nestjs/mapped-types';
import { CreateTaskDto } from './create-task.dto';
import { IsOptional, IsString, IsEnum, IsDateString } from 'class-validator';
import { Status, Category, Priority } from '../enums/task.enums';

export class UpdateTaskDto extends PartialType(CreateTaskDto) {
    @IsOptional()
    @IsEnum(Status)
    status?: Status;

    @IsOptional()
    @IsEnum(Category)
    category?: Category;

    @IsOptional()
    @IsEnum(Priority)
    priority?: Priority;

    @IsOptional()
    @IsString()
    assigned_to?: string;

    @IsOptional()
    @IsDateString()
    due_date?: string;

    @IsOptional()
    @IsString()
    location?: string
}
