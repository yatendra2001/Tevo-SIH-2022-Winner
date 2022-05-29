import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/auth/auth_repository.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/utils/session_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  LoginCubit(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(LoginState.initial());

  void sendOtpOnPhone({required String phone}) async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final isOtpSent = await _authRepository.sendOTP(phone: phone);
      SessionHelper.phone = phone;
      debugPrint("Send otp complete: $phone  $isOtpSent");
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void verifyOtp({required String otp, Map<String, dynamic>? json}) async {
    try {
      final userCredential =
          await _authRepository.verifyOTP(otp: otp, json: json);
      debugPrint("UserCredentials:  $userCredential");
      debugPrint("User uid: ${userCredential.user?.uid}");
      debugPrint(
          "Current User uid: ${auth.FirebaseAuth.instance.currentUser!.uid}");
      SessionHelper.uid = userCredential.user?.uid;
      SessionHelper.phone = userCredential.user?.phoneNumber;
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  Future<bool> checkNumber(String phone) async {
    return await _userRepository.searchUserbyPhone(query: phone);
  }
}
