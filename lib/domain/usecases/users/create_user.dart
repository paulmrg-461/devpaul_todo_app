import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class CreateUser {
  final AuthRepository authRepository;
  final UserRepository repository;

  CreateUser({required this.authRepository, required this.repository});

  Future<void> call(User newUser) async {
    User user = newUser;
    if (user.uid.isEmpty) {
      final User? registered = await authRepository.register(user);
      user = user.copyWith(uid: registered?.uid ?? '');
    }
    return repository.createUser(user);
  }
}
