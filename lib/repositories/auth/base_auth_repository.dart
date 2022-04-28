import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<auth.User> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<auth.User> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<GoogleSignInAccount> signInByGoogle();

  Future<bool> sendOTP({required String phone});

  Future<auth.UserCredential> verifyOTP({required String otp});

  Future<bool> checkUserDataExists({required String userId});

  Future<void> logOut();
}
