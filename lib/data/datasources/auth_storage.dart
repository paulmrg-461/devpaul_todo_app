import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final _storage = const FlutterSecureStorage();

  static const String _keyToken = 'auth_token';
  static const String _keyEmail = 'user_email';

  Future<void> storeToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  Future<void> storeEmail(String email) async {
    await _storage.write(key: _keyEmail, value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _keyEmail);
  }

  Future<void> deleteEmail() async {
    await _storage.delete(key: _keyEmail);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
