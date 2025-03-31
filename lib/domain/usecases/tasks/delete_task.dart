// lib/domain/usecases/delete_task.dart

import 'package:devpaul_todo_app/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  Future<void> call(String id) async {
    return repository.deleteTask(id);
  }
}
