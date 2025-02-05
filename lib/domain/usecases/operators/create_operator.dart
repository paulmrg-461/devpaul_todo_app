import 'package:devpaul_todo_app/data/models/operator_model.dart';
import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/repositories/operator_repository.dart';

class CreateOperator {
  final AuthRepository authRepository;
  final OperatorRepository repository;

  CreateOperator({required this.authRepository, required this.repository});

  Future<void> call(OperatorModel operator) async {
    final UserEntity? user = await authRepository.register(
      operator.email,
      operator.password,
    );

    final OperatorModel operatorToSave = operator.copyWith(
      uid: user?.uid ?? '',
    );
    return repository.createOperator(operatorToSave);
  }
}
