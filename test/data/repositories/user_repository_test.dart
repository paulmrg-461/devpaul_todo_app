import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';

class FakeUserRepository implements UserRepository {
  final List<User> _users = [];
  String? uploadedUrl;
  Exception? exceptionToThrow;

  @override
  Future<void> createUser(User user) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    _users.add(user);
  }

  @override
  Future<List<User>> getUsers() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return List.from(_users);
  }

  @override
  Future<void> updateUser(User user) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index >= 0) {
      _users[index] = user;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    _users.removeWhere((u) => u.id == id);
  }

  @override
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    uploadedUrl = 'https://storage.example.com/$folderName/$fileName';
    return uploadedUrl!;
  }
}

void main() {
  late FakeUserRepository repository;

  setUp(() {
    repository = FakeUserRepository();
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

  group('UserRepository', () {
    test('createUser adds user to repository', () async {
      await repository.createUser(testUser);

      final users = await repository.getUsers();
      expect(users.length, equals(1));
      expect(users.first.email, equals('test@devpaul.com'));
    });

    test('getUsers returns empty list initially', () async {
      final users = await repository.getUsers();

      expect(users, isEmpty);
    });

    test('updateUser modifies existing user', () async {
      await repository.createUser(testUser);

      final updated = testUser.copyWith(name: 'Updated Name');
      await repository.updateUser(updated);

      final users = await repository.getUsers();
      expect(users.first.name, equals('Updated Name'));
    });

    test('deleteUser removes user', () async {
      await repository.createUser(testUser);

      await repository.deleteUser(testUser.id);

      final users = await repository.getUsers();
      expect(users, isEmpty);
    });

    test('uploadFile returns URL', () async {
      final url = await repository.uploadFile(
        folderName: 'profiles',
        fileName: 'photo.png',
        fileBytes: Uint8List.fromList([1, 2, 3]),
      );

      expect(url, equals('https://storage.example.com/profiles/photo.png'));
      expect(repository.uploadedUrl, equals(url));
    });

    test('repository propagates exceptions', () async {
      repository.exceptionToThrow = Exception('Database down');

      expect(
        () => repository.getUsers(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
