import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_frontend/bloc/dto/task_dto.dart';
import 'package:task_manager_frontend/bloc/dto/update_dto.dart';
import 'package:task_manager_frontend/bloc/task_bloc.dart';

Future<UpdateTaskDTO?> showTaskDialog(BuildContext context, TaskDTO dto) async {
  final titleController = TextEditingController(text: dto.title);
  final descController = TextEditingController(text: dto.description ?? '');

  bool editTitle = false;
  bool editDescription = false;
  bool editPriority = false;
  bool editCategory = false;

  String currentPriority = dto.priority ?? 'low';
  String currentCategory = dto.category ?? 'general';
  String currentStatus = dto.status ?? 'pending';
  String originalStatus = dto.status ?? 'pending';

  return showDialog<UpdateTaskDTO>(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Task Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _editableRow(
                      label: "Title",
                      value: dto.title,
                      controller: titleController,
                      isEditing: editTitle,
                      setState: setState,
                      onEditToggle: () =>
                          setState(() => editTitle = !editTitle),
                    ),
                    const SizedBox(height: 12),

                    _editableRow(
                      label: "Description",
                      value: dto.description ?? "No description",
                      controller: descController,
                      isEditing: editDescription,
                      setState: setState,
                      maxLines: 3,
                      onEditToggle: () =>
                          setState(() => editDescription = !editDescription),
                    ),
                    const SizedBox(height: 12),

                    _dropdownRow(
                      label: "Category",
                      currentValue: currentCategory,
                      isEditing: editCategory,
                      options: const [
                        'scheduling',
                        'finance',
                        'technical',
                        'safety',
                        'general',
                      ],
                      setState: setState,
                      onEditToggle: () =>
                          setState(() => editCategory = !editCategory),
                      onChanged: (val) =>
                          setState(() => currentCategory = val!),
                    ),
                    const SizedBox(height: 12),

                    _dropdownRow(
                      label: "Priority",
                      currentValue: currentPriority,
                      isEditing: editPriority,
                      options: const ['high', 'medium', 'low'],
                      setState: setState,
                      onEditToggle: () =>
                          setState(() => editPriority = !editPriority),
                      onChanged: (val) =>
                          setState(() => currentPriority = val!),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text("Pending"),
                          selected: currentStatus == "pending",
                          onSelected: (_) =>
                              setState(() => currentStatus = "pending"),
                        ),
                        ChoiceChip(
                          label: const Text("In Progress"),
                          selected: currentStatus == "in_progress",
                          onSelected: (_) =>
                              setState(() => currentStatus = "in_progress"),
                        ),
                        ChoiceChip(
                          label: const Text("Completed"),
                          selected: currentStatus == "completed",
                          onSelected: (_) =>
                              setState(() => currentStatus = "completed"),
                        ),
                      ],
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
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Save Changes"),
                          onPressed: () {
                            final updatedFields = <String, dynamic>{};

                            if (titleController.text.trim() !=
                                dto.title.trim()) {
                              updatedFields['title'] = titleController.text
                                  .trim();
                            }
                            if (descController.text.trim() !=
                                (dto.description ?? '').trim()) {
                              updatedFields['description'] = descController.text
                                  .trim();
                            }
                            if (currentPriority != (dto.priority ?? 'low')) {
                              updatedFields['priority'] = currentPriority;
                            }
                            if (currentCategory !=
                                (dto.category ?? 'general')) {
                              updatedFields['category'] = currentCategory;
                            }
                            if (currentStatus != originalStatus) {
                              updatedFields['status'] = currentStatus;
                            }

                            if (updatedFields.isEmpty) {
                              Navigator.pop(context);
                              return;
                            }

                            final dtoResult = UpdateTaskDTO(
                              title: updatedFields['title'],
                              description: updatedFields['description'],
                              priority: updatedFields['priority'],
                              status: updatedFields['status'],
                              category: updatedFields['category']
                            );

                            BlocProvider.of<TaskBloc>(
                              context,
                            ).add(UpdateTask(id: dto.id, dto: dtoResult));

                            Navigator.pop(context, dtoResult);
                          },
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

Widget _editableRow({
  required String label,
  required String value,
  required TextEditingController controller,
  required bool isEditing,
  required void Function(VoidCallback fn) setState,
  required VoidCallback onEditToggle,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, size: 18),
            onPressed: onEditToggle,
          ),
        ],
      ),
      const SizedBox(height: 4),
      isEditing
          ? TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
    ],
  );
}

Widget _dropdownRow({
  required String label,
  required String currentValue,
  required bool isEditing,
  required List<String> options,
  required void Function(VoidCallback fn) setState,
  required VoidCallback onEditToggle,
  required void Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, size: 18),
            onPressed: onEditToggle,
          ),
        ],
      ),
      const SizedBox(height: 4),
      isEditing
          ? DropdownButtonFormField<String>(
              initialValue: currentValue,
              items: options
                  .map(
                    (val) => DropdownMenuItem(
                      value: val,
                      child: Text(val[0].toUpperCase() + val.substring(1)),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                currentValue[0].toUpperCase() + currentValue.substring(1),
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
    ],
  );
}
