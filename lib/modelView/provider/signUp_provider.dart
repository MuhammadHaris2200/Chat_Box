import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:flutter/foundation.dart';

class SignupProvider extends ChangeNotifier {
  final EmailPassword _authService;
  SignupProvider(this._authService);

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set confirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  Future<bool> signUp() async {
    await _authService.signUp(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    return true;
  }
}
