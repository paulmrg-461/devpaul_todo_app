// lib/data/models/project_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.userIds,
    required super.taskIds,
    required super.createdAt,
    required super.status,
    super.ownerId,
  });

  factory ProjectModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      userIds: List<String>.from(data['userIds'] ?? []),
      taskIds: List<String>.from(data['taskIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: TaskStatus.values[data['status'] ?? 0],
    );
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      userIds: project.userIds,
      taskIds: project.taskIds,
      createdAt: project.createdAt,
      status: project.status,
      ownerId: project.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'userIds': userIds,
      'taskIds': taskIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.index,
      if (ownerId != null) 'ownerId': ownerId,
    };
  }
}
