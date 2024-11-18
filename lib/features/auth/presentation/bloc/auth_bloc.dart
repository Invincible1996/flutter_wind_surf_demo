import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../data/datasources/auth_local_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final AuthLocalStorage storage;

  AuthBloc({required this.login, required this.storage})
      : super(AuthLoading()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);

    // Check auth status when bloc is created
    add(CheckAuthStatus());
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result = await login(
        LoginParams(email: event.email, password: event.password),
      );
      await result.fold(
        (failure) async => emit(AuthError(message: failure.toString())),
        (user) async {
          await storage.saveUser(user);
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await storage.clearUser();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await storage.getUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
