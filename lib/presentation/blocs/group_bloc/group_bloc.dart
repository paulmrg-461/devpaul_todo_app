import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/groups/group_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GetGroups getGroupsUseCase;
  final GetGroupById getGroupByIdUseCase;
  final GetGroupsByUser getGroupsByUserUseCase;
  final CreateGroup createGroupUseCase;
  final UpdateGroup updateGroupUseCase;
  final DeleteGroup deleteGroupUseCase;
  final AddUserToGroup addUserToGroupUseCase;
  final RemoveUserFromGroup removeUserFromGroupUseCase;
  final ShareGroupWithUser shareGroupWithUserUseCase;

  GroupBloc({
    required this.getGroupsUseCase,
    required this.getGroupByIdUseCase,
    required this.getGroupsByUserUseCase,
    required this.createGroupUseCase,
    required this.updateGroupUseCase,
    required this.deleteGroupUseCase,
    required this.addUserToGroupUseCase,
    required this.removeUserFromGroupUseCase,
    required this.shareGroupWithUserUseCase,
  }) : super(GroupInitial()) {
    on<GetGroupsEvent>(_onGetGroups);
    on<GetGroupsByUserEvent>(_onGetGroupsByUser);
    on<GetGroupByIdEvent>(_onGetGroupById);
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<AddUserToGroupEvent>(_onAddUserToGroup);
    on<RemoveUserFromGroupEvent>(_onRemoveUserFromGroup);
    on<ShareGroupWithUserEvent>(_onShareGroup);
  }

  Future<void> _onGetGroups(
    GetGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final groups = getGroupsUseCase();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onGetGroupsByUser(
    GetGroupsByUserEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final groups = getGroupsByUserUseCase(event.userId);
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onGetGroupById(
    GetGroupByIdEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final group = await getGroupByIdUseCase(event.groupId);
      if (group != null) {
        emit(SingleGroupLoaded(group));
      } else {
        emit(const GroupError('Group not found'));
      }
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await createGroupUseCase(event.group);
      emit(const GroupOperationSuccess('Group created'));
      add(const GetGroupsEvent());
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onUpdateGroup(
    UpdateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await updateGroupUseCase(event.group);
      emit(const GroupOperationSuccess('Group updated'));
      add(const GetGroupsEvent());
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await deleteGroupUseCase(event.groupId);
      emit(const GroupOperationSuccess('Group deleted'));
      add(const GetGroupsEvent());
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onAddUserToGroup(
    AddUserToGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await addUserToGroupUseCase(event.groupId, event.userId);
      emit(const GroupOperationSuccess('User added to group'));
      add(GetGroupByIdEvent(event.groupId));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onRemoveUserFromGroup(
    RemoveUserFromGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await removeUserFromGroupUseCase(event.groupId, event.userId);
      emit(const GroupOperationSuccess('User removed from group'));
      add(GetGroupByIdEvent(event.groupId));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onShareGroup(
    ShareGroupWithUserEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await shareGroupWithUserUseCase(event.groupId, event.userId);
      emit(const GroupOperationSuccess('Group shared'));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}
