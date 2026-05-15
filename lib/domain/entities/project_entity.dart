import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> userIds;
  final List<String> taskIds;
  final DateTime createdAt;
  final TaskStatus status;
  final String? ownerId;
  final String? groupId;
  final String? technology;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.userIds,
    required this.taskIds,
    required this.createdAt,
    required this.status,
    this.ownerId,
    this.groupId,
    this.technology,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? userIds,
    List<String>? taskIds,
    DateTime? createdAt,
    TaskStatus? status,
    String? ownerId,
    String? groupId,
    String? technology,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userIds: userIds ?? this.userIds,
      taskIds: taskIds ?? this.taskIds,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
      groupId: groupId ?? this.groupId,
      technology: technology ?? this.technology,
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
        status,
        ownerId,
        groupId,
        technology,
      ];
}

final List<String> availableTechnologies = [
  'Python',
  'JavaScript',
  'TypeScript',
  'Java',
  'Kotlin',
  'Swift',
  'Dart',
  'Flutter',
  'React',
  'Angular',
  'Vue',
  'Next.js',
  'Node.js',
  'Express',
  'PHP',
  'Laravel',
  'Ruby',
  'Go',
  'Rust',
  'C#',
  '.NET',
  'Docker',
  'AWS',
  'Firebase',
  'MongoDB',
  'PostgreSQL',
  'MySQL',
  'GraphQL',
  'REST',
];
