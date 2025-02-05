// data/models/operator_model.dart

import 'package:devpaul_todo_app/domain/entities/operator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorModel extends Operator {
  OperatorModel({
    required super.id,
    required super.name,
    required super.lastname,
    required super.dni,
    required super.signaturePhotoUrl,
    required super.uid,
    required super.email,
    required super.token,
    required super.password,
  });

  OperatorModel copyWith({
    String? id,
    String? name,
    String? lastname,
    String? dni,
    String? signaturePhotoUrl,
    String? uid,
    String? email,
    String? token,
    String? username,
    String? password,
  }) {
    return OperatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      dni: dni ?? this.dni,
      signaturePhotoUrl: signaturePhotoUrl ?? this.signaturePhotoUrl,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
    );
  }

  factory OperatorModel.fromEntity(Operator operator) {
    return OperatorModel(
      id: operator.id,
      name: operator.name,
      lastname: operator.lastname,
      email: operator.email,
      dni: operator.dni,
      signaturePhotoUrl: operator.signaturePhotoUrl,
      uid: operator.uid,
      token: operator.token,
      password: operator.password,
    );
  }

  factory OperatorModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OperatorModel(
      id: doc.id,
      name: data['name'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      dni: data['dni'] ?? '',
      signaturePhotoUrl: data['signaturePhotoUrl'] ?? '',
      uid: data['uid'] ?? '',
      token: data['token'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastname': lastname,
      'email': email,
      'dni': dni,
      'signaturePhotoUrl': signaturePhotoUrl,
      'uid': uid,
      'token': token,
      'password': password,
    };
  }

  Operator toEntity() {
    return Operator(
      id: id,
      name: name,
      lastname: lastname,
      email: email,
      dni: dni,
      signaturePhotoUrl: signaturePhotoUrl,
      uid: uid,
      token: token,
      password: password,
    );
  }
}
