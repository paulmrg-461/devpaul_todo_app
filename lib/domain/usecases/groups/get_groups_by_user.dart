import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class GetGroupsByUser {
  final GroupRepository repository;
  GetGroupsByUser(this.repository);

  Stream<List<Group>> call(String userId) => repository.getGroupsByUser(userId);
}
