import 'package:devpaul_todo_app/domain/entities/user_entity.dart';

class Operator extends UserEntity {
  final String id;
  final String name;
  final String lastname;
  final String dni;
  final String signaturePhotoUrl;

  Operator({
    required this.id,
    required this.name,
    required this.lastname,
    required this.dni,
    required this.signaturePhotoUrl,
    required super.uid,
    required super.email,
    required super.password,
    required super.token,
  });
}
