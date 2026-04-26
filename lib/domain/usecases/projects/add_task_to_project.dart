// lib/domain/usecases/projects/add_task_to_project.dart
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class AddTaskToProject {
  final ProjectRepository repository;

  AddTaskToProject(this.repository);

  Future<void> call(String projectId, String taskId) async {
    await repository.addTaskToProject(projectId, taskId);
  }
}
