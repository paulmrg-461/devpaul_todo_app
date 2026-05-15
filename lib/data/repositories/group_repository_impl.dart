import 'package:devpaul_todo_app/data/datasources/group_datasource.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupDataSource dataSource;

  GroupRepositoryImpl(this.dataSource);

  @override
  Stream<List<Group>> getGroups() => dataSource.getGroups();

  @override
  Stream<List<Group>> getGroupsByUser(String userId) =>
      dataSource.getGroupsByUser(userId);

  @override
  Future<Group?> getGroupById(String groupId) =>
      dataSource.getGroupById(groupId);

  @override
  Future<void> createGroup(Group group) => dataSource.createGroup(group);

  @override
  Future<void> updateGroup(Group group) => dataSource.updateGroup(group);

  @override
  Future<void> deleteGroup(String groupId) => dataSource.deleteGroup(groupId);

  @override
  Future<void> addUserToGroup(String groupId, String userId) =>
      dataSource.addUserToGroup(groupId, userId);

  @override
  Future<void> removeUserFromGroup(String groupId, String userId) =>
      dataSource.removeUserFromGroup(groupId, userId);

  @override
  Future<void> addProjectToGroup(String groupId, String projectId) =>
      dataSource.addProjectToGroup(groupId, projectId);

  @override
  Future<void> removeProjectFromGroup(String groupId, String projectId) =>
      dataSource.removeProjectFromGroup(groupId, projectId);

  @override
  Future<void> shareGroupWithUser(String groupId, String userId) =>
      dataSource.shareGroupWithUser(groupId, userId);
}
