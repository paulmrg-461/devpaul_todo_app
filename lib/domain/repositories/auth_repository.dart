import 'package:devpaul_todo_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> register(User user);
  Future<User?> getCurrentUser();
  Future<void> logout();
}
