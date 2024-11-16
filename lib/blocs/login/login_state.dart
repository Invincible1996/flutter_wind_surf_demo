import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? error;
  final String? email;
  final String? displayName;
  final String? avatarUrl;

  const LoginState({
    this.status = LoginStatus.initial,
    this.error,
    this.email,
    this.displayName,
    this.avatarUrl,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    String? email,
    String? displayName,
    String? avatarUrl,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [status, error, email, displayName, avatarUrl];
}
