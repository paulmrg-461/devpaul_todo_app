import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/task_repository.dart';

class GetTasksByProject {
  final TaskRepository repository;

  GetTasksByProject(this.repository);

  Stream<List<Task>> call(String projectId) {
    return repository.getTasksByProject(projectId);
  }
}
