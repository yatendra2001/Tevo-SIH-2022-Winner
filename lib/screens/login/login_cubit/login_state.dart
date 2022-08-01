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

enum ProfilePhotoStatus { initial, uploading, uploaded, error }

enum TopFollowersStatus { initial, loading, loaded, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final UsernameStatus usernameStatus;
  final TopFollowersStatus topFollowersStatus;
  final List<User> topFollowersAccount;
  final Failure failure;
  final ProfilePhotoStatus profilePhotoStatus;

  const LoginState({
    required this.status,
    required this.usernameStatus,
    required this.topFollowersStatus,
    required this.topFollowersAccount,
    required this.profilePhotoStatus,
    required this.failure,
  });

  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.initial,
      topFollowersStatus: TopFollowersStatus.initial,
      profilePhotoStatus: ProfilePhotoStatus.initial,
      usernameStatus: UsernameStatus.initial,
      topFollowersAccount: [],
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        status,
        failure,
        usernameStatus,
        profilePhotoStatus,
        topFollowersStatus,
        topFollowersAccount
      ];

  LoginState copyWith({
    LoginStatus? status,
    UsernameStatus? usernameStatus,
    ProfilePhotoStatus? profilePhotoStatus,
    TopFollowersStatus? topFollowersStatus,
    List<User>? topFollowersAccount,
    Failure? failure,
  }) {
    return LoginState(
      profilePhotoStatus: profilePhotoStatus ?? this.profilePhotoStatus,
      status: status ?? this.status,
      topFollowersStatus: topFollowersStatus ?? this.topFollowersStatus,
      usernameStatus: usernameStatus ?? this.usernameStatus,
      topFollowersAccount: topFollowersAccount ?? this.topFollowersAccount,
      failure: failure ?? this.failure,
    );
  }
}
