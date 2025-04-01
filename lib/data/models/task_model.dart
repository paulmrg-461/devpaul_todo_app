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
    required super.status,
  });

  factory TaskModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == data['priority'],
        orElse: () => TaskPriority.medium,
      ),
      type: TaskType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => TaskType.personal,
      ),
      startDate: (data['startDate'] as Timestamp).toDate(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => TaskStatus.pending,
      ),
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority.toString(),
      'type': type.toString(),
      'startDate': Timestamp.fromDate(startDate),
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status.toString(),
    };
  }
}
