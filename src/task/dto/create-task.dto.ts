import { IsString, IsOptional, IsEnum, IsDateString, IsNotEmpty } from 'class-validator';
import { Category, Priority, Status } from '../enums/task.enums';

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsEnum(Category)
  category?: Category;

  @IsOptional()
  @IsEnum(Priority)
  priority?: Priority;

  @IsOptional()
  @IsEnum(Status)
  status?: Status;

  @IsOptional()
  @IsString()
  assigned_to?: string;

  @IsOptional()
  @IsDateString()
  due_date?: string; // stored as timestamp in DB
}
