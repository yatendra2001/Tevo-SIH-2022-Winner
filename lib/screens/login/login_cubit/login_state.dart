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

enum ProfilePhotoStatus { initial, photoUploading, photoUploaded, photoError }

class LoginState extends Equatable {
  final LoginStatus status;
  final UsernameStatus usernameStatus;
  final Failure failure;
  final ProfilePhotoStatus profilePhotoStatus;

  const LoginState({
    required this.status,
    required this.usernameStatus,
    required this.profilePhotoStatus,
    required this.failure,
  });

  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.initial,
      profilePhotoStatus: ProfilePhotoStatus.initial,
      usernameStatus: UsernameStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      [status, failure, usernameStatus, profilePhotoStatus];

  LoginState copyWith({
    LoginStatus? status,
    UsernameStatus? usernameStatus,
    ProfilePhotoStatus? profilePhotoStatus,
    Failure? failure,
  }) {
    return LoginState(
      profilePhotoStatus: profilePhotoStatus ?? this.profilePhotoStatus,
      status: status ?? this.status,
      usernameStatus: usernameStatus ?? this.usernameStatus,
      failure: failure ?? this.failure,
    );
  }
}
