part of 'operator_bloc.dart';

abstract class OperatorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOperatorEvent extends OperatorEvent {
  final UserModel operator;
  final Uint8List signatureBytes;

  CreateOperatorEvent(this.operator, this.signatureBytes);

  @override
  List<Object?> get props => [operator, signatureBytes];
}

class GetOperatorsEvent extends OperatorEvent {}

class UpdateOperatorEvent extends OperatorEvent {
  final UserModel operator;

  UpdateOperatorEvent(this.operator);

  @override
  List<Object?> get props => [operator];
}

class DeleteOperatorEvent extends OperatorEvent {
  final String id;

  DeleteOperatorEvent(this.id);

  @override
  List<Object?> get props => [id];
}
