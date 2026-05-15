import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class UpdateGroup {
  final GroupRepository repository;
  UpdateGroup(this.repository);

  Future<void> call(Group group) => repository.updateGroup(group);
}
