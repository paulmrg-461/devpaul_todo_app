// lib/domain/repositories/task_repository.dart
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);
  Future<List<Task>> getTasks();
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}
