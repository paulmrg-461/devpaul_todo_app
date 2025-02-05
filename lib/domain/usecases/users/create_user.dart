import 'package:devpaul_todo_app/data/models/operator_model.dart';
import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class CreateUser {
  final AuthRepository authRepository;
  final UserRepository repository;

  CreateUser({required this.authRepository, required this.repository});

  Future<void> call(UserModel operator) async {
    final UserEntity? user = await authRepository.register(
      operator.email,
      operator.password,
    );

    final UserModel operatorToSave = operator.copyWith(
      uid: user?.uid ?? '',
    );
    return repository.createUser(operatorToSave);
  }
}
