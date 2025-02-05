// data/models/operator_model.dart

import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends User {
  UserModel({
    required super.name,
    required super.photoUrl,
    required super.uid,
    required super.email,
    required super.token,
    required super.password,
    required super.id,
  });

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? uid,
    String? email,
    String? token,
    String? username,
    String? password,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      id: id ?? this.id,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      name: user.name,
      photoUrl: user.photoUrl,
      uid: user.uid,
      email: user.email,
      token: user.token,
      password: user.password,
      id: user.id,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      token: data['token'] ?? '',
      password: data['password'] ?? '',
    );
  }

  factory UserModel.fromFirebaseUser(firebase_auth.User user, String token) {
    return UserModel(
      name: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
      uid: user.uid,
      email: user.email ?? '',
      password:
          '', // Se asigna un valor por defecto, ya que Firebase no provee la contraseña.
      token: token, // Token obtenido de Firebase.
      id: '', // Se asigna un valor por defecto o se puede manejar según la lógica de la app.
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'uid': uid,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      photoUrl: photoUrl,
      uid: uid,
      email: email,
      token: token,
      password: password,
    );
  }
}
