import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_frontend/bloc/dto/task_dto.dart';

class TaskCard extends StatelessWidget {
  final TaskDTO task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TaskCard({super.key, required this.task, this.onTap, this.onLongPress});

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'scheduling':
        return Colors.blueAccent;
      case 'finance':
        return Colors.green;
      case 'technical':
        return Colors.deepPurple;
      case 'safety':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orangeAccent;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueDate = task.dueDate != null
        ? DateFormat('MMM dd, yyyy').format(task.dueDate!)
        : 'No due date';

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (task.status ?? 'Pending').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Chip(
                    label: Text(
                      task.category?.toUpperCase() ?? 'GENERAL',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: _getCategoryColor(task.category),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 6),
                  Chip(
                    label: Text(
                      task.priority?.toUpperCase() ?? 'LOW',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: _getPriorityColor(task.priority),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.assignedTo?.isNotEmpty == true
                        ? "👤 ${task.assignedTo}"
                        : "👤 Unassigned",
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text("📅 $dueDate", style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                task.description ?? "No description provided.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
