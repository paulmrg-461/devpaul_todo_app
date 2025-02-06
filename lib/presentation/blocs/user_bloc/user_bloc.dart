import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/usecases/users/user_use_cases.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CreateUser createOperatorUseCase;
  final GetUsers getOperatorsUseCase;
  final UpdateUser updateOperatorUseCase;
  final DeleteUser deleteOperatorUseCase;
  final UploadFile uploadFileUseCase;

  UserBloc({
    required this.createOperatorUseCase,
    required this.getOperatorsUseCase,
    required this.updateOperatorUseCase,
    required this.deleteOperatorUseCase,
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
        folderName: 'operator_signatures',
        fileName: '${event.user.email}.png',
        fileBytes: event.signatureBytes,
      );

      await createOperatorUseCase(
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
      final operators = await getOperatorsUseCase();
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
      await updateOperatorUseCase(event.user);

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
      await deleteOperatorUseCase(event.id);

      // Emitir el evento para recargar la lista actualizada de users
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al eliminar el user.'));
    }
  }
}
