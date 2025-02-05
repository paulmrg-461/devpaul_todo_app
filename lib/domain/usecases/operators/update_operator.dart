import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/operator_repository.dart';

class UpdateOperator {
  final UserRepository repository;

  UpdateOperator(this.repository);

  Future<void> call(User operator) {
    return repository.updateOperator(operator);
  }
}
