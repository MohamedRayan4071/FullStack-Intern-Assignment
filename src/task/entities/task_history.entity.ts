import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from "typeorm";
import { Task } from "./task.entity";

@Entity({ name: 'task_history' })
export class TaskHistory {
  @PrimaryColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  action: string;

  @Column({ type: 'jsonb', nullable: true })
  old_value?: Record<string, any>;

  @Column({ type: 'jsonb', nullable: true })
  new_value?: Record<string, any>;

  @Column({ type: 'text' })
  changed_by: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  changed_at: Date;

  @ManyToOne(() => Task, (task) => task.id, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;
}
