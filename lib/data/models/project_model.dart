// lib/data/models/project_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required String id,
    required String name,
    required String description,
    required List<String> userIds,
    required List<String> taskIds,
    required DateTime createdAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          userIds: userIds,
          taskIds: taskIds,
          createdAt: createdAt,
        );

  factory ProjectModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      userIds: List<String>.from(data['userIds'] ?? []),
      taskIds: List<String>.from(data['taskIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'userIds': userIds,
      'taskIds': taskIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
