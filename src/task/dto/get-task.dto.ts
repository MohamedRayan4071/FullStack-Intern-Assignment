export class GetTaskDTO {
    id: string;
    title: string;
    category: string;
    priority: string;
    status: string;
    due_date: Date;
    assigned_to?: string;
    created_at: Date;
}