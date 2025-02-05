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
}
