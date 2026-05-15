import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class GetGroupById {
  final GroupRepository repository;
  GetGroupById(this.repository);

  Future<Group?> call(String groupId) => repository.getGroupById(groupId);
}
