import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/group_repository.dart';

class GetGroups {
  final GroupRepository repository;
  GetGroups(this.repository);

  Stream<List<Group>> call() => repository.getGroups();
}
