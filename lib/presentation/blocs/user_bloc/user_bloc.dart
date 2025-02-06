import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/usecases/users/user_use_cases.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CreateUser createUserUseCase;
  final GetUsers getUsersUseCase;
  final UpdateUser updateUserUseCase;
  final DeleteUser deleteUserUseCase;
  final UploadFile uploadFileUseCase;

  UserBloc({
    required this.createUserUseCase,
    required this.getUsersUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.uploadFileUseCase,
  }) : super(OperatorInitial()) {
    on<CreateUserEvent>(_onCreateOperator);
    on<GetUsersEvent>(_onGetOperators);
    on<UpdateUserEvent>(_onUpdateOperator);
    on<DeleteUserEvent>(_onDeleteOperator);
  }

  Future<void> _onCreateOperator(
    CreateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(OperatorLoading());

    try {
      final fileUrl = await uploadFileUseCase(
        folderName: 'profile_photos',
        fileName: '${event.user.email}.png',
        fileBytes: event.signatureBytes,
      );

      await createUserUseCase(
        event.user.copyWith(photoUrl: fileUrl),
      );

      // Emitir el evento para recargar la lista actualizada de users
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al crear el user: $e'));
    }
  }

  Future<void> _onGetOperators(
    GetUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      final operators = await getUsersUseCase();
      emit(OperatorSuccess(operators: operators));
    } catch (e) {
      emit(OperatorFailure('Error al obtener los users.'));
    }
  }

  Future<void> _onUpdateOperator(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      await updateUserUseCase(event.user);

      // Emitir el evento para recargar la lista actualizada de users
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al actualizar el user.'));
    }
  }

  Future<void> _onDeleteOperator(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      await deleteUserUseCase(event.id);

      // Emitir el evento para recargar la lista actualizada de users
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al eliminar el user.'));
    }
  }
}
