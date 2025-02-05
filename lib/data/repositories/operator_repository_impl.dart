// data/repositories/operator_repository_impl.dart

import 'dart:typed_data';

import 'package:devpaul_todo_app/data/datasources/firebase_storage_data_source.dart';
import 'package:devpaul_todo_app/data/datasources/operator_data_source.dart';
import 'package:devpaul_todo_app/data/models/operator_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class OperatorRepositoryImpl implements UserRepository {
  final OperatorDataSource dataSource;
  final FirebaseStorageDataSource storageDataSource;

  OperatorRepositoryImpl({
    required this.dataSource,
    required this.storageDataSource,
  });

  @override
  Future<void> createUser(User operator) async {
    final operatorModel = UserModel.fromEntity(operator);
    await dataSource.createUser(operatorModel);
  }

  @override
  Future<List<User>> getOperators() async {
    final operatorModels = await dataSource.getOperators();
    return operatorModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateOperator(User operator) async {
    final operatorModel = UserModel.fromEntity(operator);
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
