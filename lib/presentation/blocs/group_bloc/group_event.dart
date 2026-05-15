part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();
  @override
  List<Object?> get props => [];
}

class GetGroupsEvent extends GroupEvent {
  const GetGroupsEvent();
}

class GetGroupsByUserEvent extends GroupEvent {
  final String userId;
  const GetGroupsByUserEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class GetGroupByIdEvent extends GroupEvent {
  final String groupId;
  const GetGroupByIdEvent(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class CreateGroupEvent extends GroupEvent {
  final Group group;
  const CreateGroupEvent(this.group);
  @override
  List<Object?> get props => [group];
}

class UpdateGroupEvent extends GroupEvent {
  final Group group;
  const UpdateGroupEvent(this.group);
  @override
  List<Object?> get props => [group];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;
  const DeleteGroupEvent(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class AddUserToGroupEvent extends GroupEvent {
  final String groupId;
  final String userId;
  const AddUserToGroupEvent(this.groupId, this.userId);
  @override
  List<Object?> get props => [groupId, userId];
}

class RemoveUserFromGroupEvent extends GroupEvent {
  final String groupId;
  final String userId;
  const RemoveUserFromGroupEvent(this.groupId, this.userId);
  @override
  List<Object?> get props => [groupId, userId];
}

class ShareGroupWithUserEvent extends GroupEvent {
  final String groupId;
  final String userId;
  const ShareGroupWithUserEvent(this.groupId, this.userId);
  @override
  List<Object?> get props => [groupId, userId];
}
