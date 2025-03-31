import 'package:devpaul_todo_app/data/datasources/firebase_auth_data_source.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserModel?> login(String email, String password) =>
      dataSource.login(email, password);

  @override
  Future<UserModel?> register(UserModel userModel) =>
      dataSource.register(userModel);

  @override
  Future<void> logout() => dataSource.logout();

  @override
  Future<UserModel?> getCurrentUser() => dataSource.getCurrentUser();
}
