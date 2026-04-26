// lib/domain/repositories/project_repository.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';

abstract class ProjectRepository {
  Stream<List<Project>> getProjects();
  Future<Project?> getProjectById(String projectId);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String projectId);
  Future<void> addUserToProject(String projectId, String userId);
  Future<void> removeUserFromProject(String projectId, String userId);
  Future<void> addTaskToProject(String projectId, String taskId);
  Future<void> removeTaskFromProject(String projectId, String taskId);
  Stream<List<Project>> getProjectsByUser(String userId);
  Future<void> shareProjectWithUser(String projectId, String userId);
}
