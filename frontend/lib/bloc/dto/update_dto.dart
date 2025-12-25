import 'dart:convert';

class UpdateTaskDTO {
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final String? category;

  UpdateTaskDTO({
    this.title,
    this.description,
    this.priority,
    this.status,
    this.category,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (priority != null) data['priority'] = priority;
    if (status != null) data['status'] = status;
    if (category != null) data['category'] = category;

    return data;
  }

  factory UpdateTaskDTO.fromJson(Map<String, dynamic> json) => UpdateTaskDTO(
    title: json['title'],
    description: json['description'],
    priority: json['priority'],
    status: json['status'],
    category: json['category'],
  );

  @override
  String toString() => jsonEncode(toJson());
}
