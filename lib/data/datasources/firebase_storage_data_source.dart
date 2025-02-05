import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageDataSource {
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  });
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage _firebaseStorage;

  FirebaseStorageDataSourceImpl(this._firebaseStorage);

  @override
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      // Referencia al archivo en Firebase Storage
      final reference = _firebaseStorage.ref().child('$folderName/$fileName');

      // Subida del archivo
      final uploadTask = reference.putData(
          fileBytes, SettableMetadata(contentType: 'image/png'));

      // Espera a que la subida se complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Obtención de la URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error al subir el archivo: $e');
    }
  }
}
