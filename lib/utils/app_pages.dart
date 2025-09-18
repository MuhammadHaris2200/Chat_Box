import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/view/loginScreen.dart';
import 'package:chat_box/view/onBoardingScreen.dart';
import 'package:chat_box/view/signUp.dart';
import 'package:chat_box/view/splashScreen.dart';
import 'package:flutter/cupertino.dart';

import '../view/homeScreen.dart';

class AppPages{
  static Map<String,WidgetBuilder> getRoutes(){
    return{
      AppRoutes.splash: (context) => const Splashscreen(),
      AppRoutes.onBoarding: (context) => const OnboardingScreen(),
      AppRoutes.login: (context) => const Loginscreen(),
      AppRoutes.signUp: (context) => const Signup(),
      AppRoutes.home: (context) => const Homescreen(),










    };
  }
}