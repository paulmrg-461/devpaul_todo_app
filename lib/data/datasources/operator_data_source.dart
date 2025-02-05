import 'package:devpaul_todo_app/data/models/operator_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class OperatorDataSource {
  Future<void> createOperator(OperatorModel operatorModel);
  Future<List<OperatorModel>> getOperators();
  Future<void> updateOperator(OperatorModel operatorModel);
  Future<void> deleteOperator(String id);
}

class OperatorDataSourceImpl implements OperatorDataSource {
  final FirebaseFirestore firestore;

  OperatorDataSourceImpl(this.firestore);

  @override
  Future<void> createOperator(OperatorModel operatorModel) async {
    try {
      await firestore.collection('operators').add(operatorModel.toMap());
    } catch (e) {
      throw Exception('Error al crear el operador: $e');
    }
  }

  @override
  Future<List<OperatorModel>> getOperators() async {
    try {
      final querySnapshot = await firestore.collection('operators').get();
      return querySnapshot.docs
          .map((doc) => OperatorModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los operadores: $e');
    }
  }

  @override
  Future<void> updateOperator(OperatorModel operatorModel) async {
    try {
      await firestore
          .collection('operators')
          .doc(operatorModel.id)
          .update(operatorModel.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el operador: $e');
    }
  }

  @override
  Future<void> deleteOperator(String id) async {
    try {
      // Primero elimina el operador de Firestore
      await firestore.collection('operators').doc(id).delete();

      // Luego, elimina el usuario de Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Error al eliminar el operador: $e');
    }
  }
}
