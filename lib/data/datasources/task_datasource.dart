// lib/data/datasources/task_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class TaskDataSource {
  Future<List<Task>> getTasks();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskDataSourceImpl(this._firestore, this._auth);

  CollectionReference get _tasksCollection {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');
    return _firestore.collection('users').doc(user.uid).collection('tasks');
  }

  @override
  Future<List<Task>> getTasks() async {
    try {
      final querySnapshot = await _tasksCollection.get();
      return querySnapshot.docs
          .map((doc) => TaskModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener las tareas: $e');
    }
  }

  @override
  Future<void> createTask(Task task) async {
    try {
      await _tasksCollection.add((task as TaskModel).toMap());
    } catch (e) {
      throw Exception('Error al crear la tarea: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).update((task as TaskModel).toMap());
    } catch (e) {
      throw Exception('Error al actualizar la tarea: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _tasksCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar la tarea: $e');
    }
  }
}
