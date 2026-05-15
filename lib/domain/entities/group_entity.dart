import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> userIds;
  final List<String> projectIds;
  final DateTime createdAt;
  final String? ownerId;

  const Group({
    required this.id,
    required this.name,
    required this.description,
    required this.userIds,
    required this.projectIds,
    required this.createdAt,
    this.ownerId,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? userIds,
    List<String>? projectIds,
    DateTime? createdAt,
    String? ownerId,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userIds: userIds ?? this.userIds,
      projectIds: projectIds ?? this.projectIds,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userIds,
        projectIds,
        createdAt,
        ownerId,
      ];
}
