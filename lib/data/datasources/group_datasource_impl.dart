import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devpaul_todo_app/data/datasources/group_datasource.dart';
import 'package:devpaul_todo_app/data/models/group_model.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';

class GroupDataSourceImpl implements GroupDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  GroupDataSourceImpl(this.firestore, this.auth);

  CollectionReference get _collection => firestore.collection('groups');

  @override
  Stream<List<Group>> getGroups() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromSnapshot(doc).toEntity())
          .toList();
    });
  }

  @override
  Stream<List<Group>> getGroupsByUser(String userId) {
    return _collection
        .where('userIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromSnapshot(doc).toEntity())
          .toList();
    });
  }

  @override
  Future<Group?> getGroupById(String groupId) async {
    final doc = await _collection.doc(groupId).get();
    if (!doc.exists) return null;
    return GroupModel.fromSnapshot(doc).toEntity();
  }

  @override
  Future<void> createGroup(Group group) async {
    final model = GroupModel.fromEntity(group);
    await _collection.add(model.toMap());
  }

  @override
  Future<void> updateGroup(Group group) async {
    final model = GroupModel.fromEntity(group);
    if (group.id.isNotEmpty) {
      await _collection.doc(group.id).update(model.toMap());
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _collection.doc(groupId).delete();
  }

  @override
  Future<void> addUserToGroup(String groupId, String userId) async {
    await _collection.doc(groupId).update({
      'userIds': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    await _collection.doc(groupId).update({
      'userIds': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<void> addProjectToGroup(String groupId, String projectId) async {
    await _collection.doc(groupId).update({
      'projectIds': FieldValue.arrayUnion([projectId]),
    });
  }

  @override
  Future<void> removeProjectFromGroup(String groupId, String projectId) async {
    await _collection.doc(groupId).update({
      'projectIds': FieldValue.arrayRemove([projectId]),
    });
  }

  @override
  Future<void> shareGroupWithUser(String groupId, String userId) async {
    await _collection.doc(groupId).update({
      'userIds': FieldValue.arrayUnion([userId]),
    });
  }
}
