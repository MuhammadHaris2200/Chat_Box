import 'package:firebase_auth/firebase_auth.dart';

class EmailPassword {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ///is line ka mtlb agr firebase pe user ka account
      ///ban jae tw uska name bhi us account ma dal do
      await credential.user?.updateDisplayName(name);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  ///login with email & password
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

  ///Log out
  Future<void> logOut() async {
    await _auth.signOut();
  }


  ///Reset password
  Future<void> resetPassword({required String email})async{
    if(email.isEmpty){
      throw Exception("Email cannot be empty");
    }
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        throw Exception("No user found with this email");
      }else if(e.code == 'invalid-email'){
        throw Exception("Invalid email address");
      }else{
        throw Exception(e.message ?? "Something went wrong");
      }
    }

  }
}
