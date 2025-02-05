import 'package:devpaul_todo_app/domain/entities/operator.dart';
import 'package:devpaul_todo_app/domain/repositories/operator_repository.dart';

class GetOperators {
  final OperatorRepository repository;

  GetOperators(this.repository);

  Future<List<Operator>> call() {
    return repository.getOperators();
  }
}
