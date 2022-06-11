part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  submitting,
  otpSent,
  otpVerifying,
  success,

  error,
}

enum UsernameStatus { initial, usernameExists, usernameAvailable }

class LoginState extends Equatable {
  final LoginStatus status;
  final UsernameStatus usernameStatus;
  final Failure failure;

  const LoginState({
    required this.status,
    required this.usernameStatus,
    required this.failure,
  });

  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.initial,
      usernameStatus: UsernameStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, failure, usernameStatus];

  LoginState copyWith({
    LoginStatus? status,
    UsernameStatus? usernameStatus,
    Failure? failure,
  }) {
    return LoginState(
      status: status ?? this.status,
      usernameStatus: usernameStatus ?? this.usernameStatus,
      failure: failure ?? this.failure,
    );
  }
}
