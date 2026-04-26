// lib/data/repositories/project_repository_impl.dart
import 'package:devpaul_todo_app/data/datasources/project_datasource.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource dataSource;

  ProjectRepositoryImpl(this.dataSource);

  @override
  Stream<List<Project>> getProjects() {
    return dataSource.getProjects();
  }

  @override
  Future<Project?> getProjectById(String projectId) async {
    return await dataSource.getProjectById(projectId);
  }

  @override
  Future<void> createProject(Project project) async {
    await dataSource.createProject(project);
  }

  @override
  Future<void> updateProject(Project project) async {
    await dataSource.updateProject(project);
  }

  @override
  Future<void> deleteProject(String projectId) async {
    await dataSource.deleteProject(projectId);
  }

  @override
  Future<void> addUserToProject(String projectId, String userId) async {
    await dataSource.addUserToProject(projectId, userId);
  }

  @override
  Future<void> removeUserFromProject(String projectId, String userId) async {
    await dataSource.removeUserFromProject(projectId, userId);
  }

  @override
  Future<void> addTaskToProject(String projectId, String taskId) async {
    await dataSource.addTaskToProject(projectId, taskId);
  }

  @override
  Future<void> removeTaskFromProject(String projectId, String taskId) async {
    await dataSource.removeTaskFromProject(projectId, taskId);
  }

  @override
  Stream<List<Project>> getProjectsByUser(String userId) {
    return dataSource.getProjectsByUser(userId);
  }

  @override
  Future<void> shareProjectWithUser(String projectId, String userId) async {
    await dataSource.shareProjectWithUser(projectId, userId);
  }
}
