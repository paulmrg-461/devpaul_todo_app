import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class AddUserToGroup {
  final GroupRepository repository;
  AddUserToGroup(this.repository);

  Future<void> call(String groupId, String userId) =>
      repository.addUserToGroup(groupId, userId);
}
