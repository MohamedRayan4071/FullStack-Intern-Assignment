import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_frontend/bloc/task_bloc.dart';
import 'package:task_manager_frontend/count_card.dart';
import 'package:task_manager_frontend/create_task_dialog.dart';
import 'package:task_manager_frontend/delete_task_dialog.dart';
import 'package:task_manager_frontend/enum/filter_enum.dart';
import 'package:task_manager_frontend/filter_card.dart';
import 'package:task_manager_frontend/show_confirm_task_dialog.dart';
import 'package:task_manager_frontend/show_task_dialog.dart';
import 'package:task_manager_frontend/summary_card.dart';
import 'package:task_manager_frontend/task_card.dart';
import 'package:task_manager_frontend/utils/count_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "any";
  String selectedPriority = "any";

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => BlocProvider.of<TaskBloc>(context).add(GetAllTask()),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    BlocProvider.of<TaskBloc>(
      context,
    ).add(GetAllTask(category: selectedCategory, priority: selectedPriority));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("task created successfully")));
          BlocProvider.of<TaskBloc>(context).add(GetAllTask());
        }
        if (state is TaskUpdatedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("task updated successfully")));
          BlocProvider.of<TaskBloc>(context).add(GetAllTask());
        }
        if (state is TaskDeletedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("task deleted successfully")));
          BlocProvider.of<TaskBloc>(context).add(GetAllTask());
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Smart Task Manager")),
        body: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SummaryCard(
                      child: BlocBuilder<TaskBloc, TaskState>(
                        buildWhen: (p, c) => c is GetAllTaskState,
                        builder: (context, state) {
                          if (state is GetAllTaskState) {
                            final counts = countStatus(state.data);
                            return CountCard(
                              pending: counts[0],
                              inProgress: counts[1],
                              completed: counts[2],
                            );
                          }
                          return const CountCard(
                            pending: 0,
                            inProgress: 0,
                            completed: 0,
                          );
                        },
                      ),
                    ),
                    SummaryCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Category: "),
                                  FilterCard(
                                    type: FilterEnum.category,
                                    initialValue: selectedCategory,
                                    callBack: (val) =>
                                        setState(() => selectedCategory = val),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text("Priority: "),
                                  FilterCard(
                                    type: FilterEnum.priority,
                                    initialValue: selectedPriority,
                                    callBack: (val) =>
                                        setState(() => selectedPriority = val),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.filter_alt_rounded),
                                    label: const Text("Filter"),
                                    onPressed: () {
                                      BlocProvider.of<TaskBloc>(context).add(
                                        GetAllTask(
                                          category: selectedCategory,
                                          priority: selectedPriority,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = "any";
                                        selectedPriority = "any";
                                      });
                                      BlocProvider.of<TaskBloc>(
                                        context,
                                      ).add(GetAllTask());
                                    },
                                    child: const Text("Reset"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      showCreateTaskDialog(context).then((val) {
                                        if (val == null) return;
                                        showConfirmTaskDialog(
                                          context,
                                          title: val['title'],
                                          description: val['description'],
                                          selectedDateTime: val['date'],
                                          assignedTo: val['assignedTo'],
                                          priority: val['priority'],
                                          category: val['category'],
                                        );
                                      }),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Icon(Icons.add),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Create New",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                BlocBuilder<TaskBloc, TaskState>(
                  buildWhen: (p, c) =>
                      c is TaskLoadingState || c is GetAllTaskState,
                  builder: (context, state) {
                    if (state is TaskLoadingState) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 200),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is GetAllTaskState) {
                      final tasks = state.data;
                      if (tasks.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Center(child: Text("No tasks available")),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: tasks.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: (context, i) {
                          final task = tasks[i];
                          return TaskCard(
                            task: task,
                            onTap: () => showTaskDialog(context, task),
                            onLongPress: () =>
                                showTaskDeleteDialog(context, task.id),
                          );
                        },
                      );
                    }

                    return const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Center(child: Text("Unable to load tasks")),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
