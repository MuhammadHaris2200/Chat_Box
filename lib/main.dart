import 'package:chat_box/viewModel/provider/chat_service_provider.dart';
import 'package:chat_box/view/chat_screen.dart';
import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:chat_box/services/my_service/profile_service.dart';
import 'package:chat_box/utils/app_pages.dart';
import 'package:chat_box/viewModel/provider/forgot_provider.dart';
import 'package:chat_box/viewModel/provider/google_auth_provider.dart';
import 'package:chat_box/viewModel/provider/profile_provider.dart';
import 'package:chat_box/viewModel/provider/signIn_provider.dart';
import 'package:chat_box/viewModel/provider/signUp_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authService = EmailPassword();
  final profileService = ProfileService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider(authService)),
        ChangeNotifierProvider(create: (create) => SignInProvider(authService)),
        ChangeNotifierProvider(
          create: (context) => ForgotProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(profileService),
        ),
        ChangeNotifierProvider(create: (context) => GoogleAuthProvider()),
        ChangeNotifierProvider(create: (context) => ChatServiceProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Box",
      initialRoute: AppRoutes.home,
      routes: AppPages.getRoutes(),
    );
  }
}
