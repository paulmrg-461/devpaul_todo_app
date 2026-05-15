import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.description,
    required super.userIds,
    required super.projectIds,
    required super.createdAt,
    super.ownerId,
  });

  factory GroupModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      userIds: List<String>.from(data['userIds'] ?? []),
      projectIds: List<String>.from(data['projectIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ownerId: data['ownerId'],
    );
  }

  factory GroupModel.fromEntity(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      description: group.description,
      userIds: group.userIds,
      projectIds: group.projectIds,
      createdAt: group.createdAt,
      ownerId: group.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'userIds': userIds,
      'projectIds': projectIds,
      'createdAt': Timestamp.fromDate(createdAt),
      if (ownerId != null) 'ownerId': ownerId,
    };
  }

  Group toEntity() {
    return Group(
      id: id,
      name: name,
      description: description,
      userIds: userIds,
      projectIds: projectIds,
      createdAt: createdAt,
      ownerId: ownerId,
    );
  }
}
