import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:flutter/cupertino.dart';

class ForgotProvider extends ChangeNotifier{
  final EmailPassword _authService;
  ForgotProvider(this._authService);

  String _email = "";
  String get email => _email;

  set email(String value){
    _email = value;
    notifyListeners();
  }

  Future<void> resetPassword()async{
    try{
      await _authService.resetPassword(email: email);
    }catch (e){
      throw Exception(e.toString());
    }
  }
}