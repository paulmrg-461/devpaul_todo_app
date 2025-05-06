// lib/domain/usecases/projects/add_user_to_project.dart
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class AddUserToProject {
  final ProjectRepository repository;

  AddUserToProject(this.repository);

  Future<void> call(String projectId, String userId) async {
    await repository.addUserToProject(projectId, userId);
  }
}
