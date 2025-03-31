import 'package:devpaul_todo_app/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> register(UserModel userModel);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}
