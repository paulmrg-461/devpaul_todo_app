// lib/domain/usecases/projects/create_project.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class CreateProject {
  final ProjectRepository repository;

  CreateProject(this.repository);

  Future<void> call(Project project) async {
    await repository.createProject(project);
  }
}
