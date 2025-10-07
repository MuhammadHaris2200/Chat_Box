import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/flutter.dart';
import 'package:chat_box/view/forgotPassword.dart';
import 'package:chat_box/view/login.dart';
import 'package:chat_box/view/onBoardingScreen.dart';
import 'package:chat_box/view/profileScreen.dart';
import 'package:chat_box/view/signUp.dart';
import 'package:chat_box/view/splashScreen.dart';
import 'package:flutter/cupertino.dart';

import '../view/homeScreen.dart';

class AppPages {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) => const Splashscreen(),
      AppRoutes.onBoarding: (context) => const OnboardingScreen(),
      AppRoutes.login: (context) => const Flutter(),
      AppRoutes.signUp: (context) => const Signup(),
      AppRoutes.home: (context) => const HomeScreen(),
      AppRoutes.forgot: (context) => const ForgotPassword(),
      AppRoutes.profile: (context) => const ProfileScreen(),
    };
  }
}
