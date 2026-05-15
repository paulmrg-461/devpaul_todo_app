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
      // Se usa el uid como id del documento para evitar duplicados.
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
    } catch (e) {
      throw Exception('Error to create user: $e');
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
      throw Exception('Error to get users: $e');
    }
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    try {
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
    } catch (e) {
      throw Exception('Error to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      // Primero elimina el usuario de Firestore
      await firestore.collection('users').doc(id).delete();

      // Luego, elimina el usuario de Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Error to delete user: $e');
    }
  }
}
