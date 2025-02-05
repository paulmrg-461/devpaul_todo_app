// domain/usecases/register.dart
import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.register(email, password);
  }
}
