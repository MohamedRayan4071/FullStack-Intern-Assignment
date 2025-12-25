part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

final class GetAllTask extends TaskEvent {}

final class CreateTask extends TaskEvent {
  final String title;
  final String description;

  CreateTask({required this.title, required this.description});
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