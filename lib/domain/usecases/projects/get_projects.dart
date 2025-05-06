// lib/domain/usecases/projects/get_projects.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;

  GetProjects(this.repository);

  Future<List<Project>> call() async {
    return await repository.getProjects();
  }
}
