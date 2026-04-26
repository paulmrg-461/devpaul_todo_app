// lib/domain/usecases/projects/get_project_by_id.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class GetProjectById {
  final ProjectRepository repository;

  GetProjectById(this.repository);

  Future<Project?> call(String projectId) async {
    return await repository.getProjectById(projectId);
  }
}
