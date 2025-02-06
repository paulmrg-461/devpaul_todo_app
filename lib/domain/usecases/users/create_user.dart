import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class CreateUser {
  final AuthRepository authRepository;
  final UserRepository repository;

  CreateUser({required this.authRepository, required this.repository});

  Future<void> call(UserModel newUser) async {
    // Si el uid ya viene asignado, significa que el usuario ya está autenticado,
    // por lo que solo debemos crear el registro en Firestore.
    if (newUser.uid.isEmpty) {
      final UserEntity? user = await authRepository.register(
        newUser.email,
        newUser.password,
      );
      newUser = newUser.copyWith(
        uid: user?.uid ?? '',
      );
    }
    return repository.createUser(newUser);
  }
}
