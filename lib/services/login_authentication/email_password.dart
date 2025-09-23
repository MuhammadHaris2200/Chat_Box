import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/user_model.dart';

class EmailPassword {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  ///Sign up with name email & password
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
      ///yaha aik user create kiya with email & password
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ///phir jo user create hova ha uski uid
      String uid = credential.user!.uid;

      ///phir aik collection banayi ha firestore ma
      ///us collection ma aik document banayi ha with uid
      ///jis ma user ki detail store krvayi ha
      await _firestore.collection('users').doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "about": "Hey there I am using ChatBox",
        "phone": "",
        "profilePic": "",
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });

      ///is line ka mtlb agr firebase pe user ka account
      ///ban jae tw uska name bhi us account ma dal do
      await credential.user?.updateDisplayName(name);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  ///login with email & password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      ///yaha aik user login kiya with email & password
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ///login user ki uid
      String uid = credential.user!.uid;

      ///or yaha login user ka data firestore se uid ki help se get krliya
      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        throw Exception("User not found");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  ///Log out
  Future<void> logOut() async {
    await _auth.signOut();
  }

  ///Reset password
  Future<void> resetPassword({required String email}) async {
    if (email.isEmpty) {
      throw Exception("Email cannot be empty");
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found with this email");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email address");
      } else {
        throw Exception(e.message ?? "Something went wrong");
      }
    }
  }
}
