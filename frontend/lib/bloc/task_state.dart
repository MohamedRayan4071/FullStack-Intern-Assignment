// ignore_for_file: non_constant_identifier_names

part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class GetAllTaskState extends TaskState {
  final List<TaskDTO> data;

  GetAllTaskState({required this.data});
}

final class ErrorGettingTaskState extends TaskState {
  final String message;

  ErrorGettingTaskState({required this.message});
}

final class TaskLoadingState extends TaskState {}

final class TaskCreatedState extends TaskState {}

final class ErrorCreatingTaskState extends TaskState {
  final String message;

  ErrorCreatingTaskState({required this.message});
}

final class TaskUpdatedState extends TaskState {}

final class ErrorUpdatingTaskState extends TaskState {
  final String message;

  ErrorUpdatingTaskState({required this.message});
}

final class TaskDeletedState extends TaskState {}

final class ErrorDeletingTaskState extends TaskState {
  final String message;

  ErrorDeletingTaskState({required this.message});
}

final class GotAutoGenDataState extends TaskState {
  final String? priority;

  final String? category;

  final DateTime? due_date;

  final String? assigned_to;

  GotAutoGenDataState({
    required this.priority,
    required this.category,
    required this.due_date,
    required this.assigned_to,
  });
}

final class ErrorGettingAutoGenDataState extends TaskState {
  final String message;

  ErrorGettingAutoGenDataState({required this.message});
}

final class LoadingGettingAutoGenDataState extends TaskState {}