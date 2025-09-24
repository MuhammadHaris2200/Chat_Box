import 'package:chat_box/model/user_model.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:flutter/foundation.dart';

class SignInProvider extends ChangeNotifier {
  final EmailPassword _authService;
  SignInProvider(this._authService);
  UserModel? _user;
  UserModel? get user => _user;

  String _email = "";
  String _password = "";

  String get email => _email;
  String get password => _password;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  ///Sign in with email & password with use of provider
  Future<bool> signIn() async {
    try {
      ///yaha aik user login kiya with email & password
      final user = await _authService.signIn(email: email, password: password);

      ///phir check kr rhe ha k agr user login hogya ha
      ///tw (UserModel) ka jo data ha vo login user ma dal do
      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
