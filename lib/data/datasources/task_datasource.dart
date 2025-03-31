// lib/data/datasources/task_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

abstract class TaskDataSource {
  Future<void> createTask(Task task);
  Future<List<Task>> getTasks(String userId);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore firestore;

  TaskDataSourceImpl(this.firestore);

  @override
  Future<void> createTask(Task task) async {
    final taskModel = task is TaskModel
        ? task
        : TaskModel(
            id: task.id,
            name: task.name,
            description: task.description,
            priority: task.priority,
            type: task.type,
            startDate: task.startDate,
            dueDate: task.dueDate,
            userId: task.userId,
          );
    // Usamos el id del task (puedes generar un id único con UUID o usar Firestore autoID)
    await firestore
        .collection('tasks')
        .doc(taskModel.id)
        .set(taskModel.toMap());
  }

  @override
  Future<List<Task>> getTasks(String userId) async {
    final querySnapshot = await firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => TaskModel.fromSnapshot(doc))
        .toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = task is TaskModel
        ? task
        : TaskModel(
            id: task.id,
            name: task.name,
            description: task.description,
            priority: task.priority,
            type: task.type,
            startDate: task.startDate,
            dueDate: task.dueDate,
            userId: task.userId,
          );
    await firestore
        .collection('tasks')
        .doc(taskModel.id)
        .update(taskModel.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await firestore.collection('tasks').doc(id).delete();
  }
}
