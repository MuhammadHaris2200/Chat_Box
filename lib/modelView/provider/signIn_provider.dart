import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:flutter/foundation.dart';

class SigninProvider extends ChangeNotifier {
  final EmailPassword _authService;
  SigninProvider(this._authService);

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

  Future<bool> signIn() async {
    await _authService.signIn(email: email, password: password);
    return true;
  }
}
