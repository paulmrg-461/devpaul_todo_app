import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/domain/usecases/users/user_use_cases.dart';
import 'package:equatable/equatable.dart';

part 'operator_event.dart';
part 'operator_state.dart';

class OperatorBloc extends Bloc<OperatorEvent, OperatorState> {
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
    on<CreateOperatorEvent>(_onCreateOperator);
    on<GetOperatorsEvent>(_onGetOperators);
    on<UpdateOperatorEvent>(_onUpdateOperator);
    on<DeleteOperatorEvent>(_onDeleteOperator);
  }

  Future<void> _onCreateOperator(
    CreateOperatorEvent event,
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
        event.user.copyWith(signaturePhotoUrl: fileUrl),
      );

      // Emitir el evento para recargar la lista actualizada de operadores
      add(GetOperatorsEvent());
    } catch (e) {
      emit(OperatorFailure('Error al crear el operador: $e'));
    }
  }

  Future<void> _onGetOperators(
    GetOperatorsEvent event,
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
    UpdateOperatorEvent event,
    Emitter<OperatorState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      await updateOperatorUseCase(event.user);

      // Emitir el evento para recargar la lista actualizada de operadores
      add(GetOperatorsEvent());
    } catch (e) {
      emit(OperatorFailure('Error al actualizar el operador.'));
    }
  }

  Future<void> _onDeleteOperator(
    DeleteOperatorEvent event,
    Emitter<OperatorState> emit,
  ) async {
    emit(OperatorLoading());
    try {
      await deleteOperatorUseCase(event.id);

      // Emitir el evento para recargar la lista actualizada de operadores
      add(GetOperatorsEvent());
    } catch (e) {
      emit(OperatorFailure('Error al eliminar el operador.'));
    }
  }
}
