part of 'operator_bloc.dart';

abstract class OperatorState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class OperatorInitial extends OperatorState {}

final class OperatorLoading extends OperatorState {}

final class OperatorSuccess extends OperatorState {
  final List<User>? operators;

  OperatorSuccess({this.operators});

  @override
  List<Object?> get props => [operators];
}

class OperatorFailure extends OperatorState {
  final String message;

  OperatorFailure(this.message);

  @override
  List<Object?> get props => [message];
}
