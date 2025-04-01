// lib/data/datasources/task_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

abstract class TaskDataSource {
  Future<List<Task>> getTasks();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'tasks';

  TaskDataSourceImpl(this._firestore);

  @override
  Future<List<Task>> getTasks() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> createTask(Task task) async {
    await _firestore.collection(_collection).doc(task.id).set(
          TaskModel.fromEntity(task).toMap(),
        );
  }

  @override
  Future<void> updateTask(Task task) async {
    await _firestore.collection(_collection).doc(task.id).update(
          TaskModel.fromEntity(task).toMap(),
        );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection(_collection).doc(taskId).delete();
  }
}
