import 'package:devpaul_todo_app/data/datasources/firebase_auth_data_source.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User?> login(String email, String password) =>
      dataSource.login(email, password);

  @override
  Future<User?> register(User user) => dataSource.register(user);

  @override
  Future<void> logout() => dataSource.logout();

  @override
  Future<User?> getCurrentUser() => dataSource.getCurrentUser();
}
