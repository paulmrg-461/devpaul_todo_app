// data/repositories/operator_repository_impl.dart

import 'dart:typed_data';

import 'package:devpaul_todo_app/data/datasources/firebase_storage_data_source.dart';
import 'package:devpaul_todo_app/data/datasources/operator_data_source.dart';
import 'package:devpaul_todo_app/data/models/operator_model.dart';
import 'package:devpaul_todo_app/domain/entities/operator.dart';
import 'package:devpaul_todo_app/domain/repositories/operator_repository.dart';

class OperatorRepositoryImpl implements OperatorRepository {
  final OperatorDataSource dataSource;
  final FirebaseStorageDataSource storageDataSource;

  OperatorRepositoryImpl({
    required this.dataSource,
    required this.storageDataSource,
  });

  @override
  Future<void> createOperator(Operator operator) async {
    final operatorModel = OperatorModel.fromEntity(operator);
    await dataSource.createOperator(operatorModel);
  }

  @override
  Future<List<Operator>> getOperators() async {
    final operatorModels = await dataSource.getOperators();
    return operatorModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateOperator(Operator operator) async {
    final operatorModel = OperatorModel.fromEntity(operator);
    await dataSource.updateOperator(operatorModel);
  }

  @override
  Future<void> deleteOperator(String id) {
    return dataSource.deleteOperator(id);
  }

  @override
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) {
    return storageDataSource.uploadFile(
      folderName: folderName,
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
