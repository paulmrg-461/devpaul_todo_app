// domain/usecases/delete_operator.dart

import 'package:devpaul_todo_app/domain/repositories/operator_repository.dart';

class DeleteOperator {
  final UserRepository repository;

  DeleteOperator(this.repository);

  Future<void> call(String id) {
    return repository.deleteOperator(id);
  }
}
