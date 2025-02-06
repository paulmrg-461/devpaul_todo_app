import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserDataSource {
  Future<void> createUser(UserModel userModel);
  Future<List<UserModel>> getUsers();
  Future<void> updateUser(UserModel userModel);
  Future<void> deleteUser(String id);
}

class UserDataSourceImpl implements UserDataSource {
  final FirebaseFirestore firestore;

  UserDataSourceImpl(this.firestore);

  @override
  Future<void> createUser(UserModel userModel) async {
    try {
      await firestore.collection('users').add(userModel.toMap());
    } catch (e) {
      throw Exception('Error al crear el user: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los users: $e');
    }
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    try {
      await firestore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el user: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      // Primero elimina el user de Firestore
      await firestore.collection('users').doc(id).delete();

      // Luego, elimina el usuario de Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Error al eliminar el user: $e');
    }
  }
}
