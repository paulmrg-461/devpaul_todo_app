import 'package:devpaul_todo_app/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Stream<List<Group>> getGroupsByUser(String userId);
  Future<Group?> getGroupById(String groupId);
  Future<void> createGroup(Group group);
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(String groupId);
  Future<void> addUserToGroup(String groupId, String userId);
  Future<void> removeUserFromGroup(String groupId, String userId);
  Future<void> addProjectToGroup(String groupId, String projectId);
  Future<void> removeProjectFromGroup(String groupId, String projectId);
  Future<void> shareGroupWithUser(String groupId, String userId);
  Stream<List<Group>> getGroups();
}
