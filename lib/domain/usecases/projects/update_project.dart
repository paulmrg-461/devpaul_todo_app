// lib/domain/usecases/projects/update_project.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class UpdateProject {
  final ProjectRepository repository;

  UpdateProject(this.repository);

  Future<void> call(Project project) async {
    await repository.updateProject(project);
  }
}
