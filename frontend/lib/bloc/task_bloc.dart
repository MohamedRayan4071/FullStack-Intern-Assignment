import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_frontend/bloc/dto/task_dto.dart';
import 'package:task_manager_frontend/bloc/dto/update_dto.dart';

part 'task_event.dart';
part 'task_state.dart';

int hostBit = 1;

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  static final String baseUrl = (hostBit == 1)
      ? "https://full-stack-intern-assignment.vercel.app/api/tasks"
      : "http://localhost:5000/api/tasks";

  TaskBloc() : super(TaskInitial()) {
    on<GetAllTask>(_onGetAllTask);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<GetAutoGenData>(_onAutoGenData);
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      final uri = Uri.parse("$baseUrl/${event.id}");
      final response = await http.delete(uri);
      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(TaskDeletedState());
      } else {
        emit(
          ErrorDeletingTaskState(
            message:
                "Failed to create task: ${response.statusCode} ${response.reasonPhrase}",
          ),
        );
      }
    } catch (err) {
      emit(ErrorUpdatingTaskState(message: err.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      final uri = Uri.parse("$baseUrl/${event.id}");
      final response = await http.patch(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(event.dto),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        emit(TaskUpdatedState());
      } else {
        emit(
          ErrorUpdatingTaskState(
            message:
                "Failed to create task: ${response.statusCode} ${response.reasonPhrase}",
          ),
        );
      }
    } catch (err) {
      emit(ErrorUpdatingTaskState(message: err.toString()));
    }
  }

  Future<void> _onAutoGenData(
    GetAutoGenData event,
    Emitter<TaskState> emit,
  ) async {
    try {
      print("hi");
      emit(LoadingGettingAutoGenDataState());
      final uri = Uri.parse("$baseUrl/auto-gen-data");
      print(uri.path);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": event.title,
          "description": event.description,
          "dateTime": event.date,
          "assignedTo": event.assignedTo,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body);
        DateTime? parsedDueDate;
        final rawDate = body['due_date'];

        if (rawDate is String && rawDate.isNotEmpty) {
          parsedDueDate = DateTime.tryParse(rawDate);
        }

        emit(
          GotAutoGenDataState(
            priority: body['priority'] ?? '',
            category: body['category'] ?? '',
            due_date: parsedDueDate,
            assigned_to: body['assigned_to'] ?? '',
          ),
        );
      } else {
        print(jsonDecode(response.body));
        emit(
          ErrorGettingAutoGenDataState(
            message:
                "Failed to create task: ${response.statusCode} ${response.reasonPhrase}",
          ),
        );
      }
    } catch (err) {
      emit(ErrorCreatingTaskState(message: err.toString()));
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState()); 

    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": event.title,
          "description": event.description,
          "dateTime": event.dueDate?.toIso8601String(),
          "assignedTo": event.assignedTo,
          "category": event.category,
          "priority": event.priority
        }),
      );

      if (response.statusCode == 201) {
        emit(TaskCreatedState());
      } else {
        emit(
          ErrorCreatingTaskState(
            message:
                "Failed to create task: ${response.statusCode} ${response.reasonPhrase}",
          ),
        );
      }
    } catch (err) {
      emit(ErrorCreatingTaskState(message: err.toString()));
    }
  }

  Future<void> _onGetAllTask(GetAllTask event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());

    try {
      bool isCat = false;
      String url = baseUrl;
      if (event.category != null) {
        url += "?cat=${event.category!}";
        isCat = true;
      }
      if (event.priority != null) {
        url += "${isCat ? "&" : "?"}pr=${event.priority!}";
      }

      print(url);
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final tasks = jsonList.map((e) => TaskDTO.fromJson(e)).toList();
        emit(GetAllTaskState(data: tasks));
      } else {
        emit(
          ErrorGettingTaskState(
            message:
                "Failed to fetch tasks: ${response.statusCode} ${response.reasonPhrase}",
          ),
        );
      }
    } catch (err) {
      emit(ErrorGettingTaskState(message: err.toString()));
    }
  }
}
