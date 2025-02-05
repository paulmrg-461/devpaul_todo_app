import 'package:devpaul_todo_app/domain/entities/operator.dart';
import 'package:devpaul_todo_app/domain/repositories/operator_repository.dart';

class UpdateOperator {
  final OperatorRepository repository;

  UpdateOperator(this.repository);

  Future<void> call(Operator operator) {
    return repository.updateOperator(operator);
  }
}
