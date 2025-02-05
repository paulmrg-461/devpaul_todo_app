// data/models/operator_model.dart

import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  UserModel({
    required super.name,
    required super.photoUrl,
    required super.uid,
    required super.email,
    required super.token,
    required super.password,
  });

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? uid,
    String? email,
    String? token,
    String? username,
    String? password,
  }) {
    return UserModel(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
    );
  }

  factory UserModel.fromEntity(User operator) {
    return UserModel(
      name: operator.name,
      photoUrl: operator.photoUrl,
      uid: operator.uid,
      email: operator.email,
      token: operator.token,
      password: operator.password,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      token: data['token'] ?? '',
      password: data['password'] ?? '',
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
      name: name,
      photoUrl: photoUrl,
      uid: uid,
      email: email,
      token: token,
      password: password,
    );
  }
}
