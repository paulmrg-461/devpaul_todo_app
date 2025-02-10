import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/data/datasources/auth_storage.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:devpaul_todo_app/domain/usecases/authentication/authentication_use_cases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final Register registerUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final AuthStorage authStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.getCurrentUserUseCase,
    required this.authStorage,
  }) : super(AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthCheckUserEvent>(_onCheckUser);
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);
      if (user != null) {
        // Almacena el token y el correo
        await authStorage.storeToken(
          user.token,
        ); // Asumiendo que UserEntity tiene un campo token
        await authStorage.storeEmail(event.email);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authStorage.clear(); // Limpia el almacenamiento al hacer logout
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(event.userModel);
      if (user != null) {
        await authStorage.storeToken(user.token);
        await authStorage.storeEmail(event.userModel.email);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      if (e.toString().contains("already in use")) {
        // Si el correo ya está en uso, se intenta iniciar sesión con ese usuario
        try {
          final user = await loginUseCase(
              event.userModel.email, event.userModel.password);
          if (user != null) {
            await authStorage.storeToken(user.token);
            await authStorage.storeEmail(event.userModel.email);
            emit(AuthAuthenticated(user));
          } else {
            emit(AuthError('Login failed after duplicate registration'));
          }
        } catch (loginError) {
          emit(AuthError(loginError.toString()));
        }
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> _onCheckUser(
    AuthCheckUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final token = await authStorage.getToken();
    if (token != null) {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
