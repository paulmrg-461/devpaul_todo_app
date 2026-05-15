import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class RemoveUserFromGroup {
  final GroupRepository repository;
  RemoveUserFromGroup(this.repository);

  Future<void> call(String groupId, String userId) =>
      repository.removeUserFromGroup(groupId, userId);
}
