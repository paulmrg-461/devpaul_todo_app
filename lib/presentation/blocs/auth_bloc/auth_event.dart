part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  AuthLoginEvent(this.email, this.password);
}

class AuthLogoutEvent extends AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  final UserModel userModel;
  AuthRegisterEvent(this.userModel);
}

class AuthCheckUserEvent extends AuthEvent {}
