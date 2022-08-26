import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/repositories/wallet_repository/wallet_repo.dart';
import 'package:tevo/utils/session_helper.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<auth.User?> _userSubscription;
  bool isFirstTime = false;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.unknown()) {
    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      // await StreamChat.of(event.context).client.disconnectUser();
      await _authRepository.logOut();
    }
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    if (event.user != null) {
      final check =
          await _authRepository.checkUserDataExists(userId: event.user!.uid);
      if (check) {
        final user =
            await UserRepository().getUserWithId(userId: event.user!.uid);
        SessionHelper.uid = event.user?.uid ?? '';
        SessionHelper.displayName = user.displayName;
        SessionHelper.phone = user.phone;
        SessionHelper.profileImageUrl = user.profileImageUrl;
        SessionHelper.username = user.username;
        SessionHelper.completed = user.completed;
        SessionHelper.todo = user.todo;
      }
      yield AuthState.authenticated(user: event.user!, check: check);
    } else {
      yield AuthState.unauthenticated();
    }
  }
}
