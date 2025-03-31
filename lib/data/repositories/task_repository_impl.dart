// lib/data/repositories/task_repository_impl.dart
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/task_repository.dart';
import 'package:devpaul_todo_app/data/datasources/task_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<void> createTask(Task task) async {
    return dataSource.createTask(task);
  }

  @override
  Future<List<Task>> getTasks() async {
    return dataSource.getTasks();
  }

  @override
  Future<void> updateTask(Task task) async {
    return dataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    return dataSource.deleteTask(id);
  }
}
