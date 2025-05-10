// lib/domain/repositories/task_repository.dart
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Stream<List<Task>> getTasksByProject(String projectId);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
