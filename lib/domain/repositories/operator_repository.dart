import 'dart:typed_data';

import 'package:devpaul_todo_app/domain/entities/operator.dart';

abstract class OperatorRepository {
  Future<void> createOperator(Operator operator);
  Future<List<Operator>> getOperators();
  Future<void> updateOperator(Operator operator);
  Future<void> deleteOperator(String id);
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  });
}
