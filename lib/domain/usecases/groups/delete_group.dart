import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class DeleteGroup {
  final GroupRepository repository;
  DeleteGroup(this.repository);

  Future<void> call(String groupId) => repository.deleteGroup(groupId);
}
