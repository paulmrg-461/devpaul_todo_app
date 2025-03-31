// lib/domain/usecases/get_tasks.dart

import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<List<Task>> call(String userId) async {
    return repository.getTasks(userId);
  }
}
