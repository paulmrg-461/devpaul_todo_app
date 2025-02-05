import 'package:devpaul_todo_app/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.password,
    required super.token,
  });

  factory UserModel.fromFirebaseUser(User user, String token) {
    return UserModel(
      uid: user.uid,
      email: user.email!,
      password: '', // Aquí asignas un valor por defecto
      token: token, // Aquí pasas el token
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'password': password, 'token': token};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
    );
  }
}
