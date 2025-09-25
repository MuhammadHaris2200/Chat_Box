import 'package:chat_box/services/login_authentication/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GoogleAuthProvider extends ChangeNotifier{
  ///Google Auth service class ka instance
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  ///Current user
  User? _user;
  User? get user => _user;


  ///Sign in with google
  Future<void> signInWithGoogle()async{
    try{
      final user = await _googleAuthService.signInWithGoogle();
      _user = user;
      notifyListeners();
    }catch(e){
      throw Exception(e.toString());
    }
  }


  ///Log out function
  void logOut()async{
    try{
      await FirebaseAuth.instance.signOut();
      _user = null;
      notifyListeners();
    }catch(e){
      throw Exception("Log out failed $e");
    }
  }

}