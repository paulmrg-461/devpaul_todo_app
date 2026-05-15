import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  Future<User?> call() {
    return repository.getCurrentUser();
  }
}
