// lib/domain/entities/task.dart
import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

enum TaskType { work, personal, academic, leisure }

enum TaskStatus { pending, inProgress, completed }

class Task extends Equatable {
  final String id;
  final String name;
  final String description;
  final TaskPriority priority;
  final TaskType type;
  final DateTime startDate;
  final DateTime dueDate;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.type,
    required this.startDate,
    required this.dueDate,
    required this.status,
  });

  Task copyWith({
    String? id,
    String? name,
    String? description,
    TaskPriority? priority,
    TaskType? type,
    DateTime? startDate,
    DateTime? dueDate,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        priority,
        type,
        startDate,
        dueDate,
        status,
      ];
}
