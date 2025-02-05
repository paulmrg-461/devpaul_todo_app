import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class GetOperators {
  final UserRepository repository;

  GetOperators(this.repository);

  Future<List<User>> call() {
    return repository.getUsers();
  }
}
