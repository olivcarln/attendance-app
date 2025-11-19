import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices() {
    if (!kIsWeb) {
      //only for android or ios
      FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );
    }
  }
  // get current user
  User? get currentUser => _auth.currentUser;

  // auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'operation=not=allowed') {
          throw 'Email/Password sign up is not enabled, Please enable on firebase console.';
        }
      }
      rethrow;
    }
  }

    // sign out
    Future<void> signOut() async{
      try {
        await _auth.signOut();
      } catch (e) {
        rethrow;
      }
    }
}
