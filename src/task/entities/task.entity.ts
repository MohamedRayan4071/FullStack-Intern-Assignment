import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany, JoinColumn } from 'typeorm';
import * as entityInterface from '../predefined/entity.interface';
import { TaskHistory } from './task_history.entity';

@Entity({ name: 'tasks' })
export class Task {
  @PrimaryColumn('uuid', { name: 'id' })
  id!: string;

  @Column({ type: 'text', nullable: false })
  title!: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'text', nullable: true })
  category?: string

  @Column({ type: 'text', nullable: true })
  priority?: string;

  @Column({ type: 'text', nullable: true })
  status?: string;

  @Column({ type: 'text', nullable: true })
  assigned_to?: string;

  @Column({ type: 'timestamp', nullable: true })
  due_date?: Date;

  @Column({ type: 'jsonb', nullable: true })
  extracted_entities?: entityInterface.Entity;

  @Column({ type: 'jsonb', nullable: true })
  suggested_actions?: string[];

  @CreateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at!: Date;

  @UpdateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at!: Date;

  @OneToMany(() => TaskHistory, (taskHistory: TaskHistory) => taskHistory.task)
  taskHistory?: TaskHistory[]
}
