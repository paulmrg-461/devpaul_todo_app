part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateUserEvent extends UserEvent {
  final UserModel user;
  final Uint8List signatureBytes;

  CreateUserEvent(this.user, this.signatureBytes);

  @override
  List<Object?> get props => [user, signatureBytes];
}

class GetUsersEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final UserModel user;

  UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final String id;

  DeleteUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}
