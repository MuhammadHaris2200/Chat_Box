import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class EmailPassword {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  //Sign up with name email & password
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception("password do not match");
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //is line ka mtlb agr firebase pe user ka account
      //ban jae tw uska name bhi us account ma dal do
      await credential.user?.updateDisplayName(name);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  //login with email & password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  //Log out
  Future<void> logOut() async {
    await _auth.signOut();
  }
}
