import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class ShareProjectWithUser {
  final ProjectRepository projectRepository;
  ShareProjectWithUser(this.projectRepository);

  Future<void> call(String projectId, String userId) async {
    await projectRepository.shareProjectWithUser(projectId, userId);
  }
}
