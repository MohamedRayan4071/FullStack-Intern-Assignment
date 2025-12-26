import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_frontend/bloc/task_bloc.dart';

Future<Map<String, dynamic>?> showCreateTaskDialog(BuildContext context) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final assignedToController = TextEditingController();
  DateTime? selectedDateTime;

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is LoadingGettingAutoGenDataState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("getting auto generated data...")),
            );
          }
          if (state is ErrorGettingAutoGenDataState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          }
          if (state is GotAutoGenDataState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("successfully fetched the auto generated data"),
              ),
            );
            print("hi bro I am rayna");
            Navigator.pop(context, {
              'title': titleController.text.trim(),
              'description': descController.text.trim(),
              'date': state.due_date,
              'assignedTo': state.assigned_to,
              'priority': state.priority,
              'category': state.category,
            });
          }
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create New Task",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: descController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                cancelText: "Cancel",
                                confirmText: "Select",
                              );

                              if (pickedDate != null) {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  cancelText: "Cancel",
                                  confirmText: "Select",
                                );

                                if (pickedTime != null) {
                                  final combinedDateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );

                                  setState(
                                    () => selectedDateTime = combinedDateTime,
                                  );
                                }
                              }
                            },
                            child: const Text("Select Date & Time"),
                          ),
                          Text(
                            (selectedDateTime != null)
                                ? selectedDateTime.toString()
                                : "",
                          ),
                        ],
                      ),
                      TextField(
                        controller: assignedToController,
                        decoration: const InputDecoration(
                          labelText: "Assigning to",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final title = titleController.text.trim();
                              final desc = descController.text.trim();
                              final assign = assignedToController.text.trim();

                              if (title.isEmpty || desc.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please fill all fields"),
                                  ),
                                );
                                return;
                              }
                              BlocProvider.of<TaskBloc>(context).add(
                                GetAutoGenData(
                                  title: title,
                                  description: desc,
                                  date: selectedDateTime?.toIso8601String(),
                                  assignedTo: assign,
                                ),
                              );
                            },
                            child: const Text("Create"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
