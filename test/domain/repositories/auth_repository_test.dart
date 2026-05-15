import 'package:flutter_test/flutter_test.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
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
  late FakeAuthRepository repository;

  setUp(() {
    repository = FakeAuthRepository();
  });

  final testUser = User(
    id: '1',
    uid: 'firebase-uid-1',
    email: 'test@devpaul.com',
    name: 'Test User',
    password: 'password123',
    token: 'firebase-token-abc',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('AuthRepository', () {
    test('login returns user on success', () async {
      repository.userToReturn = testUser;

      final result = await repository.login('test@devpaul.com', 'password123');

      expect(result, equals(testUser));
      expect(result?.email, equals('test@devpaul.com'));
      expect(result?.name, equals('Test User'));
    });

    test('login returns null when no user', () async {
      repository.userToReturn = null;

      final result = await repository.login('wrong@email.com', 'wrong');

      expect(result, isNull);
    });

    test('login throws on error', () async {
      repository.exceptionToThrow = Exception('Network error');

      expect(
        () => repository.login('test@devpaul.com', 'password'),
        throwsA(isA<Exception>()),
      );
    });

    test('register returns user on success', () async {
      repository.userToReturn = testUser;

      final result = await repository.register(testUser);

      expect(result, equals(testUser));
    });

    test('logout is called successfully', () async {
      await repository.logout();

      expect(repository.logoutCalled, isTrue);
    });

    test('getCurrentUser returns existing user', () async {
      repository.userToReturn = testUser;

      final result = await repository.getCurrentUser();

      expect(result, equals(testUser));
    });

    test('getCurrentUser returns null when not authenticated', () async {
      repository.userToReturn = null;

      final result = await repository.getCurrentUser();

      expect(result, isNull);
    });
  });

  group('User entity', () {
    test('User copyWith preserves unchanged fields', () {
      final updated = testUser.copyWith(name: 'New Name');

      expect(updated.name, equals('New Name'));
      expect(updated.email, equals(testUser.email));
      expect(updated.id, equals(testUser.id));
      expect(updated.uid, equals(testUser.uid));
    });

    test('User copyWith changes multiple fields', () {
      final updated = testUser.copyWith(
        name: 'Updated',
        email: 'updated@devpaul.com',
        photoUrl: 'https://example.com/new.jpg',
      );

      expect(updated.name, equals('Updated'));
      expect(updated.email, equals('updated@devpaul.com'));
      expect(updated.photoUrl, equals('https://example.com/new.jpg'));
    });
  });
}
