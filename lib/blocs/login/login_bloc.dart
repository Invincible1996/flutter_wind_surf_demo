import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Add actual authentication logic here
      // For now, we'll just check if the email contains @ and password length
      if (!event.email.contains('@')) {
        throw Exception('Invalid email format');
      }
      if (event.password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Mock user data - in a real app, this would come from your backend
      final displayName = event.email.split('@')[0];
      // Using GitHub's identicon as avatar
      final avatarUrl = 'https://github.com/identicons/$displayName.png';

      // Save user data to local storage
      await StorageService.saveUserData(
        email: event.email,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );

      emit(state.copyWith(
        status: LoginStatus.success,
        email: event.email,
        displayName: displayName,
        avatarUrl: avatarUrl,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    await StorageService.clearUserData();
    emit(const LoginState());
  }

  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<LoginState> emit,
  ) async {
    final userData = await StorageService.getUserData();
    if (userData != null) {
      emit(state.copyWith(
        status: LoginStatus.success,
        email: userData['email'] as String,
        displayName: userData['displayName'] as String,
        avatarUrl: userData['avatarUrl'] as String,
      ));
    }
  }
}
