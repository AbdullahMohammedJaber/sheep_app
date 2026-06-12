import 'package:equatable/equatable.dart';
import 'package:sheep/util/enum.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final AuthStatus loginStatus;
  final AuthStatus registerStatus;
  final AuthStatus forgotPasswordStatus;
  final AuthStatus verifyCodeStatus;
  final String? errorMessage;
  final String? token;
  final UserRole? userRole;
  const AuthState({
    this.loginStatus = AuthStatus.initial,
    this.registerStatus = AuthStatus.initial,
    this.forgotPasswordStatus = AuthStatus.initial,
    this.verifyCodeStatus = AuthStatus.initial,
    this.errorMessage,
    this.token,
    this.userRole,
  });

  AuthState copyWith({
    AuthStatus? loginStatus,
    AuthStatus? registerStatus,
    AuthStatus? forgotPasswordStatus,
    AuthStatus? verifyCodeStatus,
    String? errorMessage,
    String? token,
    UserRole? userRole,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      verifyCodeStatus: verifyCodeStatus ?? this.verifyCodeStatus,
      errorMessage: errorMessage,
      token: token ?? this.token,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  List<Object?> get props => [
    loginStatus,
    registerStatus,
    forgotPasswordStatus,
    verifyCodeStatus,
    errorMessage,
    token,
    userRole,
  ];
}
