part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User? user;
  final AuthStatus status;
  final bool? isUserExist;
  final bool? isOnline;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
    this.isUserExist,
    this.isOnline,
  });

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated(
      {required auth.User user, required bool check}) {
    return AuthState(
        user: user, status: AuthStatus.authenticated, isUserExist: check);
  }

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [user, status, isUserExist];
}
