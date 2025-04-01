// lib/data/models/task_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

class TaskModel extends Task {
  final String? aiSuggestion;

  TaskModel({
    required String id,
    required String name,
    required String description,
    required TaskPriority priority,
    required TaskType type,
    required DateTime startDate,
    required DateTime dueDate,
    required TaskStatus status,
    this.aiSuggestion,
  }) : super(
          id: id,
          name: name,
          description: description,
          priority: priority,
          type: type,
          startDate: startDate,
          dueDate: dueDate,
          status: status,
        );

  factory TaskModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      priority: _getPriorityFromString(data['priority'] ?? 'medium'),
      type: _getTypeFromString(data['type'] ?? 'work'),
      startDate: (data['startDate'] as Timestamp).toDate(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      status: _getStatusFromString(data['status'] ?? 'pending'),
      aiSuggestion: data['aiSuggestion'],
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      name: task.name,
      description: task.description,
      priority: task.priority,
      type: task.type,
      startDate: task.startDate,
      dueDate: task.dueDate,
      status: task.status,
      aiSuggestion: task is TaskModel ? task.aiSuggestion : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority.toString().split('.').last,
      'type': type.toString().split('.').last,
      'startDate': Timestamp.fromDate(startDate),
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status.toString().split('.').last,
      if (aiSuggestion != null) 'aiSuggestion': aiSuggestion,
    };
  }

  static TaskPriority _getPriorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return TaskPriority.low;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }

  static TaskType _getTypeFromString(String type) {
    switch (type) {
      case 'personal':
        return TaskType.personal;
      case 'academic':
        return TaskType.academic;
      case 'leisure':
        return TaskType.leisure;
      default:
        return TaskType.work;
    }
  }

  static TaskStatus _getStatusFromString(String status) {
    switch (status) {
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  TaskModel copyWith({
    String? id,
    String? name,
    String? description,
    TaskPriority? priority,
    TaskType? type,
    DateTime? startDate,
    DateTime? dueDate,
    TaskStatus? status,
    String? aiSuggestion,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      aiSuggestion: aiSuggestion ?? this.aiSuggestion,
    );
  }
}
