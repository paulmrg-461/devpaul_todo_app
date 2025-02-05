part of 'operator_bloc.dart';

abstract class OperatorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOperatorEvent extends OperatorEvent {
  final UserModel user;
  final Uint8List signatureBytes;

  CreateOperatorEvent(this.user, this.signatureBytes);

  @override
  List<Object?> get props => [user, signatureBytes];
}

class GetOperatorsEvent extends OperatorEvent {}

class UpdateOperatorEvent extends OperatorEvent {
  final UserModel user;

  UpdateOperatorEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteOperatorEvent extends OperatorEvent {
  final String id;

  DeleteOperatorEvent(this.id);

  @override
  List<Object?> get props => [id];
}
