// lib/data/datasources/project_datasource_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/data/datasources/project_datasource.dart';
import 'package:devpaul_todo_app/data/models/project_model.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectDataSourceImpl implements ProjectDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProjectDataSourceImpl(this._firestore, this._auth);

  // Asumiendo que los proyectos se almacenan por usuario, similar a las tareas.
  // Si los proyectos son compartidos, la estructura de la colección podría variar.
  CollectionReference get _projectsCollection {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');
    // Podría ser una colección raíz 'projects' o anidada bajo 'users'
    // Por simplicidad, la anidaremos bajo el usuario por ahora.
    return _firestore.collection('users').doc(user.uid).collection('projects');
  }

  @override
  Future<List<Project>> getProjects() async {
    try {
      final querySnapshot = await _projectsCollection.get();
      return querySnapshot.docs
          .map((doc) => ProjectModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los proyectos: $e');
    }
  }

  @override
  Future<Project?> getProjectById(String projectId) async {
    try {
      final docSnapshot = await _projectsCollection.doc(projectId).get();
      if (docSnapshot.exists) {
        return ProjectModel.fromSnapshot(docSnapshot);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el proyecto por ID: $e');
    }
  }

  @override
  Future<void> createProject(Project project) async {
    try {
      final projectModel = ProjectModel(
        id: '', // Firestore generará el ID
        name: project.name,
        description: project.description,
        userIds: project.userIds,
        taskIds: project.taskIds,
        createdAt: project.createdAt,
        status: project.status,
      );
      await _projectsCollection.add(projectModel.toMap());
    } catch (e) {
      throw Exception('Error al crear el proyecto: $e');
    }
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
