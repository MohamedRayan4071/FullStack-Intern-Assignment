class TaskDTO {
  final String id;
  final String title;
  final String? description;
  final String? category;
  final String? priority;
  final String? status;
  final String? assignedTo;
  final DateTime? dueDate;
  final Map<String, dynamic>? extractedEntities;
  final List<String>? suggestedActions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskDTO({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.priority,
    this.status,
    this.assignedTo,
    this.dueDate,
    this.extractedEntities,
    this.suggestedActions,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) => TaskDTO(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        category: json['category'],
        priority: json['priority'],
        status: json['status'],
        assignedTo: json['assigned_to'],
        dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
        extractedEntities: json['extracted_entities'] != null
            ? Map<String, dynamic>.from(json['extracted_entities'])
            : null,
        suggestedActions: json['suggested_actions'] != null
            ? List<String>.from(json['suggested_actions'])
            : null,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'priority': priority,
        'status': status,
        'assigned_to': assignedTo,
        'due_date': dueDate?.toIso8601String(),
        'extracted_entities': extractedEntities,
        'suggested_actions': suggestedActions,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
