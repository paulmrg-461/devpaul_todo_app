import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class CreateUser {
  final AuthRepository authRepository;
  final UserRepository repository;

  CreateUser({required this.authRepository, required this.repository});

  Future<void> call(UserModel newUser) async {
    final UserEntity? user = await authRepository.register(
      newUser.email,
      newUser.password,
    );

    final UserModel userToSave = newUser.copyWith(
      uid: user?.uid ?? '',
    );
    return repository.createUser(userToSave);
  }
}
