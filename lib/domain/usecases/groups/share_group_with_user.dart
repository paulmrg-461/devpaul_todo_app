import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class ShareGroupWithUser {
  final GroupRepository repository;
  ShareGroupWithUser(this.repository);

  Future<void> call(String groupId, String userId) =>
      repository.shareGroupWithUser(groupId, userId);
}
