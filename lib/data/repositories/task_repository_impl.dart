// lib/data/repositories/task_repository_impl.dart
import 'package:devpaul_todo_app/data/datasources/task_datasource.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<List<Task>> getTasks() async {
    return await dataSource.getTasks();
  }

  @override
  Future<void> createTask(Task task) async {
    await dataSource.createTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await dataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await dataSource.deleteTask(taskId);
  }

  @override
  Stream<List<Task>> getTasksByProject(String projectId) =>
      dataSource.getTasksByProject(projectId);
}
