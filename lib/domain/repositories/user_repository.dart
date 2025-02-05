import 'dart:typed_data';

import 'package:devpaul_todo_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User operator);
  Future<List<User>> getUsers();
  Future<void> updateUser(User operator);
  Future<void> deleteUser(String id);
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  });
}
