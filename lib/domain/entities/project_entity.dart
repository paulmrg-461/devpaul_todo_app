// lib/domain/entities/project_entity.dart
import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> userIds; // IDs de los usuarios asociados al proyecto
  final List<String> taskIds; // IDs de las tareas asociadas al proyecto
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.userIds,
    required this.taskIds,
    required this.createdAt,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? userIds,
    List<String>? taskIds,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userIds: userIds ?? this.userIds,
      taskIds: taskIds ?? this.taskIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userIds,
        taskIds,
        createdAt,
      ];
}
