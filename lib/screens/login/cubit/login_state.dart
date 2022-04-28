part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;
  final bool isDataEmpty;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
    required this.isDataEmpty,
  });

  factory LoginState.initial() {
    return LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      failure: const Failure(),
      isDataEmpty: false,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, password, status, failure, isDataEmpty];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    Failure? failure,
    bool? isDataEmpty,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isDataEmpty: isDataEmpty ?? this.isDataEmpty,
    );
  }
}
