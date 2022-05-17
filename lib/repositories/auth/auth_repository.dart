import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

class AuthRepository extends BaseAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;
  final usersRef = FirebaseFirestore.instance.collection('users');

  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<bool> checkUserDataExists({required String userId}) async {
    String _errorMessage = 'Something went wrong';
    try {
      final user = await usersRef.doc(userId).get();
      return user.exists;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
    }
    throw Exception(_errorMessage);
  }

  String _verificationId = "";
  int? _resendToken;
  @override
  Future<bool> sendOTP({required String phone}) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (auth.PhoneAuthCredential credential) {},
      verificationFailed: (auth.FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        _resendToken = resendToken;
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = _verificationId;
      },
    );
    debugPrint("_verificationId: $_verificationId");
    return true;
  }

  @override
  Future<auth.UserCredential> verifyOTP(
      {required String otp, Map<String, dynamic>? json}) async {
    auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    final credentials = await _firebaseAuth.signInWithCredential(credential);
    if (json != null && credentials.user != null) {
      _firebaseFirestore
          .collection(Paths.users)
          .doc(credentials.user?.uid)
          .set(json);
    }

    return credentials;
  }

  @override
  Future<void> logOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
