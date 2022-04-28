import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void logInWithCredentials() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final user = await _authRepository.signInByGoogle();
      final check = await _authRepository.checkUserDataExists(
          userId: FirebaseAuth.instance.currentUser!.uid);
      emit(check
          ? state.copyWith(status: LoginStatus.success, isDataEmpty: true)
          : state.copyWith(status: LoginStatus.success, isDataEmpty: false));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void sendOtpOnPhone({required String phone}) async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final isOtpSent = await _authRepository.sendOTP(phone: phone);
      debugPrint("Send otp complete: $phone  $isOtpSent");
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void verifyOtp({required String otp}) async {
    try {
      final userCredential = await _authRepository.verifyOTP(otp: otp);
      final check = await _authRepository.checkUserDataExists(
          userId: FirebaseAuth.instance.currentUser!.uid);
      debugPrint("UserCredentials:  $userCredential");
      debugPrint("User uid: ${userCredential.user?.uid}");
      debugPrint("Current User uid: ${FirebaseAuth.instance.currentUser!.uid}");
      emit(check
          ? state.copyWith(status: LoginStatus.success, isDataEmpty: true)
          : state.copyWith(status: LoginStatus.success, isDataEmpty: false));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
