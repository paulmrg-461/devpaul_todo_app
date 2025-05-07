// lib/data/datasources/project_datasource_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/data/datasources/project_datasource.dart';
import 'package:devpaul_todo_app/data/models/project_model.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectDataSourceImpl implements ProjectDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CollectionReference _projectsCollection;
  final CollectionReference _tasksCollection;

  ProjectDataSourceImpl(this._firestore, this._auth)
      : _projectsCollection = _firestore.collection('projects'),
        _tasksCollection = _firestore.collection('tasks');

  @override
  Stream<List<Project>> getProjects() =>
      _projectsCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => ProjectModel.fromSnapshot(doc)).toList());

  @override
  Stream<List<Project>> getProjectsByUser(String userId) => _projectsCollection
      .where('userIds', arrayContains: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ProjectModel.fromSnapshot(doc)).toList());

  @override
  Future<Project> getProjectById(String projectId) async {
    try {
      final doc = await _projectsCollection.doc(projectId).get();
      if (!doc.exists) {
        throw Exception('Proyecto no encontrado');
      }
      return ProjectModel.fromSnapshot(doc);
    } catch (e) {
      throw Exception('Error al obtener el proyecto: $e');
    }
  }

  @override
  Future<void> shareProjectWithUser(String projectId, String userId) async {
    try {
      await _projectsCollection.doc(projectId).update({
        'userIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception('Error al compartir el proyecto: $e');
    }
  }

  @override
  Future<String> createProject(Project project) async {
    final docRef =
        await _projectsCollection.add(ProjectModel.fromEntity(project).toMap());
    return docRef.id;
  }

  @override
  Future<void> updateProject(Project project) async {
    try {
      final projectModel = ProjectModel(
        id: project.id,
        name: project.name,
        description: project.description,
        userIds: project.userIds,
        taskIds: project.taskIds,
        createdAt: project.createdAt,
        status: project.status,
      );
      await _projectsCollection.doc(project.id).update(projectModel.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el proyecto: $e');
    }
  }

  @override
  Future<void> deleteProject(String projectId) async {
    try {
      await _projectsCollection.doc(projectId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el proyecto: $e');
    }
  }

  @override
  Future<void> addUserToProject(String projectId, String userId) async {
    try {
      await _projectsCollection.doc(projectId).update({
        'userIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception('Error al añadir usuario al proyecto: $e');
    }
  }

  @override
  Future<void> removeUserFromProject(String projectId, String userId) async {
    try {
      await _projectsCollection.doc(projectId).update({
        'userIds': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      throw Exception('Error al eliminar usuario del proyecto: $e');
    }
  }

  @override
  Future<void> addTaskToProject(String projectId, String taskId) async {
    final batch = _firestore.batch();

    batch.update(_projectsCollection.doc(projectId), {
      'taskIds': FieldValue.arrayUnion([taskId])
    });

    batch.update(_tasksCollection.doc(taskId), {'projectId': projectId});

    await batch.commit();
    try {
      await _projectsCollection.doc(projectId).update({
        'taskIds': FieldValue.arrayUnion([taskId])
      });
    } catch (e) {
      throw Exception('Error al añadir tarea al proyecto: $e');
    }
  }

  @override
  Future<void> removeTaskFromProject(String projectId, String taskId) async {
    try {
      await _projectsCollection.doc(projectId).update({
        'taskIds': FieldValue.arrayRemove([taskId])
      });
    } catch (e) {
      throw Exception('Error al eliminar tarea del proyecto: $e');
    }
  }
}
