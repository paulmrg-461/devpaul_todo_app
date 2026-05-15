import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);

  Future<User?> call(User user) {
    return repository.register(user);
  }
}
