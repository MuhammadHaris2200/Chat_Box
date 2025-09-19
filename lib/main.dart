import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/utils/app_pages.dart';
import 'package:chat_box/view/practice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Practice(),
      title: "Chat Box",
      // initialRoute: AppRoutes.login,
      // routes: AppPages.getRoutes(),
    );
  }
}

