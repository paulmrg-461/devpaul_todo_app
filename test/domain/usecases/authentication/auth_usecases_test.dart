import 'package:flutter_test/flutter_test.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/usecases/authentication/login.dart';
import 'package:devpaul_todo_app/domain/usecases/authentication/register.dart';
import 'package:devpaul_todo_app/domain/usecases/authentication/logout.dart';
import 'package:devpaul_todo_app/domain/usecases/authentication/get_current_user.dart';

class MockAuthRepository implements AuthRepository {
  User? userToReturn;
  bool logoutCalled = false;
  Exception? exceptionToThrow;

  @override
  Future<User?> login(String email, String password) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userToReturn;
  }

  @override
  Future<User?> register(User user) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userToReturn;
  }

  @override
  Future<void> logout() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    logoutCalled = true;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userToReturn;
  }
}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  final testUser = User(
    id: '1',
    uid: 'firebase-uid-1',
    email: 'test@devpaul.com',
    name: 'Test User',
    password: 'password123',
    token: 'token-abc',
    photoUrl: '',
  );

  group('Login', () {
    test('returns user when credentials are valid', () async {
      repository.userToReturn = testUser;
      final useCase = Login(repository);

      final result = await useCase('test@devpaul.com', 'password123');

      expect(result, equals(testUser));
    });

    test('returns null when credentials are invalid', () async {
      repository.userToReturn = null;
      final useCase = Login(repository);

      final result = await useCase('bad@email.com', 'wrong');

      expect(result, isNull);
    });

    test('propagates exceptions', () async {
      repository.exceptionToThrow = Exception('Auth service down');
      final useCase = Login(repository);

      expect(
        () => useCase('test@devpaul.com', 'password'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Register', () {
    test('returns user on successful registration', () async {
      repository.userToReturn = testUser;
      final useCase = Register(repository);

      final result = await useCase(testUser);

      expect(result, equals(testUser));
    });

    test('propagates exceptions', () async {
      repository.exceptionToThrow = Exception('Email already in use');
      final useCase = Register(repository);

      expect(
        () => useCase(testUser),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Logout', () {
    test('calls repository logout successfully', () async {
      final useCase = Logout(repository);

      await useCase();

      expect(repository.logoutCalled, isTrue);
    });

    test('propagates exceptions', () async {
      repository.exceptionToThrow = Exception('Logout failed');
      final useCase = Logout(repository);

      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('GetCurrentUser', () {
    test('returns user when authenticated', () async {
      repository.userToReturn = testUser;
      final useCase = GetCurrentUser(repository);

      final result = await useCase();

      expect(result, equals(testUser));
    });

    test('returns null when not authenticated', () async {
      repository.userToReturn = null;
      final useCase = GetCurrentUser(repository);

      final result = await useCase();

      expect(result, isNull);
    });
  });
}
