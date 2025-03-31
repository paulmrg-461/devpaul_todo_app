// lib/data/models/task_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    required super.description,
    required super.priority,
    required super.type,
    required super.startDate,
    required super.dueDate,
    super.isCompleted,
  });

  factory TaskModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      priority: _mapStringToPriority(data['priority']),
      type: _mapStringToType(data['type']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': _mapPriorityToString(priority),
      'type': _mapTypeToString(type),
      'startDate': Timestamp.fromDate(startDate),
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    };
  }

  static TaskPriority _mapStringToPriority(String priority) {
    switch (priority) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }

  static String _mapPriorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
    }
  }

  static TaskType _mapStringToType(String type) {
    switch (type) {
      case 'work':
        return TaskType.work;
      case 'personal':
        return TaskType.personal;
      case 'academic':
        return TaskType.academic;
      case 'leisure':
        return TaskType.leisure;
      default:
        return TaskType.personal;
    }
  }

  static String _mapTypeToString(TaskType type) {
    switch (type) {
      case TaskType.work:
        return 'work';
      case TaskType.personal:
        return 'personal';
      case TaskType.academic:
        return 'academic';
      case TaskType.leisure:
        return 'leisure';
    }
  }
}
