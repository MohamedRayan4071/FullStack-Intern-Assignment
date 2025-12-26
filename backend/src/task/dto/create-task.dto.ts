import { IsString, IsOptional, IsNotEmpty, IsDateString, IsEnum } from 'class-validator';
import { Category, Priority } from '../enums/task.enums';

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  title!: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsDateString()
  dateTime? : Date

  @IsOptional()
  @IsString()
  assignedTo?: string

  @IsNotEmpty()
  @IsEnum(Category)
  category : Category | undefined

  @IsNotEmpty()
  @IsEnum(Priority)
  priority: Priority | undefined
}
