// lib/domain/usecases/projects/remove_user_from_project.dart
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class RemoveUserFromProject {
  final ProjectRepository repository;

  RemoveUserFromProject(this.repository);

  Future<void> call(String projectId, String userId) async {
    await repository.removeUserFromProject(projectId, userId);
  }
}
