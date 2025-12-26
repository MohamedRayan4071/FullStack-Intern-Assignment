import { IsString, IsOptional, IsNotEmpty, IsDateString, IsEnum } from 'class-validator';

export class AutoGenDTO {
  @IsString()
  @IsNotEmpty()
  title!: string;

  @IsNotEmpty()
  @IsString()
  description!: string;

  @IsOptional()
  @IsDateString()
  dateTime? : Date

  @IsOptional()
  @IsString()
  assignedTo?: string
}
