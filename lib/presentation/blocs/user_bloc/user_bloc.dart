import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/usecases/users/user_use_cases.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class OperatorBloc extends Bloc<UserEvent, OperatorState> {
  final CreateUser createOperatorUseCase;
  final GetUsers getOperatorsUseCase;
  final UpdateUser updateOperatorUseCase;
  final DeleteUser deleteOperatorUseCase;
  final UploadFile uploadFileUseCase;

  OperatorBloc({
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
    Emitter<OperatorState> emit,
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

      // Emitir el evento para recargar la lista actualizada de operadores
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al crear el user: $e'));
    }
  }

  Future<void> _onGetOperators(
    GetUsersEvent event,
    Emitter<OperatorState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      final operators = await getOperatorsUseCase();
      emit(OperatorSuccess(operators: operators));
    } catch (e) {
      emit(OperatorFailure('Error al obtener los operadores.'));
    }
  }

  Future<void> _onUpdateOperator(
    UpdateUserEvent event,
    Emitter<OperatorState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      await updateOperatorUseCase(event.user);

      // Emitir el evento para recargar la lista actualizada de operadores
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al actualizar el user.'));
    }
  }

  Future<void> _onDeleteOperator(
    DeleteUserEvent event,
    Emitter<OperatorState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      await deleteOperatorUseCase(event.id);

      // Emitir el evento para recargar la lista actualizada de operadores
      add(GetUsersEvent());
    } catch (e) {
      emit(OperatorFailure('Error al eliminar el user.'));
    }
  }
}
