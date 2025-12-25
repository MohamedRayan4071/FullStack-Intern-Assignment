import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_frontend/bloc/dto/task_dto.dart';
import 'package:task_manager_frontend/bloc/task_bloc.dart';
import 'package:task_manager_frontend/create_task_dialog.dart';
import 'package:task_manager_frontend/delete_task_dialog.dart';
import 'package:task_manager_frontend/show_task_dialog.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => TaskBloc()..add(GetAllTask()),
      child: const TaskApp(),
    ),
  );
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> Function() _onRefresh(BuildContext context) {
    return () async => {
      await Future.delayed(Duration(milliseconds: 500)),
      BlocProvider.of<TaskBloc>(context).add(GetAllTask()),
    };
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TaskBloc>(context).add(GetAllTask());
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Task Manager")),
      body: RefreshIndicator(
        onRefresh: _onRefresh(context),
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is ErrorGettingTaskState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "please check you internet connection or turn off aeroplane mode",
                  ),
                ),
              );
            }
            if (state is ErrorCreatingTaskState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              BlocProvider.of<TaskBloc>(context).add(GetAllTask());
            }
            if (state is ErrorUpdatingTaskState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              BlocProvider.of<TaskBloc>(context).add(GetAllTask());
            }
            if (state is ErrorDeletingTaskState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              BlocProvider.of<TaskBloc>(context).add(GetAllTask());
            }
            if (state is TaskCreatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("task created successfully")),
              );
              BlocProvider.of<TaskBloc>(context).add(GetAllTask());
            }
            if (state is TaskUpdatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("task updated successfully")),
              );
              BlocProvider.of<TaskBloc>(context).add(GetAllTask());
            }
            if (state is TaskDeletedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("task deleted successfully")),
              );
              BlocProvider.of<TaskBloc>(context).add(GetAllTask());
            }
          },
          builder: (context, state) {
            if (state is TaskLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetAllTaskState) {
              final List<TaskDTO> tasks = state.data;

              if (tasks.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 300),
                    const Center(child: Text("No tasks available")),
                  ],
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    onTap: () => showTaskDialog(context, task),
                    onLongPress: () => showTaskDeleteDialog(context, task.id),
                    title: Text(task.title),
                    subtitle: Text(
                      "${task.category?.toUpperCase() ?? 'GENERAL'} • ${task.priority?.toUpperCase() ?? 'LOW'}",
                    ),
                    trailing: Text(task.status?.toUpperCase() ?? "PENDING"),
                  );
                },
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 300),
                Center(child: Text("Can't get data")),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
