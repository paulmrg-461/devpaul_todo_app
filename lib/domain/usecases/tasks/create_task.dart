import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;
  CreateTask(this.repository);

  Future<void> call(Task task) async {
    return repository.createTask(task);
  }
}
