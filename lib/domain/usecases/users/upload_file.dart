import 'dart:typed_data';

import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class UploadFile {
  final UserRepository repository;

  UploadFile(this.repository);

  Future<String> call({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) {
    return repository.uploadFile(
      folderName: folderName,
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
