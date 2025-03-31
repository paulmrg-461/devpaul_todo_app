// domain/usecases/register.dart
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);

  Future<UserModel?> call(UserModel userModel) {
    return repository.register(userModel);
  }
}
