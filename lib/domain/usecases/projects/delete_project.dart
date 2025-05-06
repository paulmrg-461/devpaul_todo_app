// lib/domain/usecases/projects/delete_project.dart
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class DeleteProject {
  final ProjectRepository repository;

  DeleteProject(this.repository);

  Future<void> call(String projectId) async {
    await repository.deleteProject(projectId);
  }
}
