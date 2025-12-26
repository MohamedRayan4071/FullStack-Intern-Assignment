part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

final class GetAllTask extends TaskEvent {
  final String? category;
  final String? priority;

  GetAllTask({this.category, this.priority});
}


final class CreateTask extends TaskEvent {
  final String title;
  final String description;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? priority;
  final String? category;

  CreateTask({required this.title, required this.description, this.dueDate, this.assignedTo, this.priority, this.category});
}

final class UpdateTask extends TaskEvent {
  final UpdateTaskDTO dto;
  final String id;

  UpdateTask({required this.dto, required this.id});
}

final class DeleteTask extends TaskEvent {
  final String id;

  DeleteTask({required this.id});
}

final class GetAutoGenData extends TaskEvent {
  final String title;
  final String description;
  final String? date;
  final String? assignedTo;

  GetAutoGenData({required this.title, required this.description, required this.date, required this.assignedTo});
}
