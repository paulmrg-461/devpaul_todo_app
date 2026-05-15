import 'package:devpaul_todo_app/domain/entities/user_entity.dart';

class User extends UserEntity {
  final String name;
  final String photoUrl;

  User({
    required this.name,
    required this.photoUrl,
    required super.uid,
    required super.email,
    required super.password,
    required super.token,
    required super.id,
  });

  User copyWith({
    String? name,
    String? photoUrl,
    String? uid,
    String? email,
    String? password,
    String? token,
    String? id,
  }) {
    return User(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      id: id ?? this.id,
    );
  }
}
