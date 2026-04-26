// lib/domain/usecases/projects/remove_task_from_project.dart
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class RemoveTaskFromProject {
  final ProjectRepository repository;

  RemoveTaskFromProject(this.repository);

  Future<void> call(String projectId, String taskId) async {
    await repository.removeTaskFromProject(projectId, taskId);
  }
}
