// lib/domain/entities/task.dart
import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

enum TaskType { work, personal, academic, leisure }

class Task extends Equatable {
  final String id;
  final String name;
  final String description;
  final TaskPriority priority;
  final TaskType type;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.type,
    required this.startDate,
    required this.dueDate,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props =>
      [id, name, description, priority, type, startDate, dueDate, isCompleted];
}
