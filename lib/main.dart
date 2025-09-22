import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/modelView/provider/signIn_provider.dart';
import 'package:chat_box/modelView/provider/signUp_provider.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:chat_box/utils/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authService = EmailPassword();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider(authService)),
        ChangeNotifierProvider(create: (create) => SigninProvider(authService)),
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
      initialRoute: AppRoutes.signUp,
      routes: AppPages.getRoutes(),
    );
  }
}
