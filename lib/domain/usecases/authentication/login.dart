import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.login(email, password);
  }
}
