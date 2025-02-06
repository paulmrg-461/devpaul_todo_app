part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class OperatorInitial extends UserState {}

final class OperatorLoading extends UserState {}

final class OperatorSuccess extends UserState {
  final List<User>? operators;

  OperatorSuccess({this.operators});

  @override
  List<Object?> get props => [operators];
}

class OperatorFailure extends UserState {
  final String message;

  OperatorFailure(this.message);

  @override
  List<Object?> get props => [message];
}
