import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_frontend/bloc/task_bloc.dart';

Future<Map<String, String>?> showConfirmTaskDialog(
  BuildContext context, {
  required String title,
  required String description,
  DateTime? selectedDateTime,
  String? assignedTo,
  String? priority,
  String? category,
}) async {
  final assignedToController = TextEditingController(text: assignedTo ?? '');

  String selectedPriority = (priority ?? 'any').toLowerCase();
  String selectedCategory = (category ?? 'any').toLowerCase();

  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
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
                      "Confirm Task Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: TextEditingController(text: title),
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: TextEditingController(text: description),
                      readOnly: true,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDateTime != null
                                ? "Date: ${selectedDateTime?.toLocal().toString().split(' ')[0]}  "
                                      "Time: ${selectedDateTime?.toLocal().hour.toString().padLeft(2, '0')}:${selectedDateTime?.toLocal().minute.toString().padLeft(2, '0')}"
                                : "No date selected",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDateTime ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                  selectedDateTime ?? DateTime.now(),
                                ),
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  selectedDateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: const Text("Change"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: assignedToController,
                      decoration: const InputDecoration(
                        labelText: "Assigned To",
                        hintText: "Optional",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          alignment: Alignment.centerLeft,
                          value: selectedPriority,
                          items: const [
                            DropdownMenuItem(value: "any", child: Text("Any")),
                            DropdownMenuItem(
                              value: "high",
                              child: Text("High"),
                            ),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("Medium"),
                            ),
                            DropdownMenuItem(value: "low", child: Text("Low")),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            setState(() => selectedPriority = val);
                          },
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 14, height: 1.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          alignment: Alignment.centerLeft,
                          value: selectedCategory,
                          items: const [
                            DropdownMenuItem(value: "any", child: Text("Any")),
                            DropdownMenuItem(
                              value: "scheduling",
                              child: Text("Scheduling"),
                            ),
                            DropdownMenuItem(
                              value: "finance",
                              child: Text("Finance"),
                            ),
                            DropdownMenuItem(
                              value: "technical",
                              child: Text("Technical"),
                            ),
                            DropdownMenuItem(
                              value: "safety",
                              child: Text("Safety"),
                            ),
                            DropdownMenuItem(
                              value: "general",
                              child: Text("General"),
                            ),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            setState(() => selectedCategory = val);
                          },
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 14, height: 1.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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
                            BlocProvider.of<TaskBloc>(context).add(
                              CreateTask(
                                title: title,
                                description: description,
                                assignedTo: assignedToController.text.trim(),
                                category: category,
                                priority: priority,
                                dueDate: selectedDateTime,
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          child: const Text("Confirm & Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
