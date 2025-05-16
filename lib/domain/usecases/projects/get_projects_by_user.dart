import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/domain_repositories.dart';

class GetProjectsByUser {
  final ProjectRepository projectRepository;

  GetProjectsByUser(this.projectRepository);

  Stream<List<Project>> call(String userId) {
    return projectRepository.getProjectsByUser(userId);
  }
}
