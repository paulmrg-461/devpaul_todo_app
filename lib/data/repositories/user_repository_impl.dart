// data/repositories/operator_repository_impl.dart

import 'dart:typed_data';

import 'package:devpaul_todo_app/data/datasources/firebase_storage_data_source.dart';
import 'package:devpaul_todo_app/data/datasources/user_data_source.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;
  final FirebaseStorageDataSource storageDataSource;

  UserRepositoryImpl({
    required this.dataSource,
    required this.storageDataSource,
  });

  @override
  Future<void> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await dataSource.createUser(userModel);
  }

  @override
  Future<List<User>> getUsers() async {
    final operatorModels = await dataSource.getUsers();
    return operatorModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await dataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(String id) {
    return dataSource.deleteUser(id);
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
