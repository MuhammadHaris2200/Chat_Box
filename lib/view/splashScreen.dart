import 'package:chat_box/constants/app_images.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.pushReplacementNamed(context, "/onBoarding");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        ///Chat box image
        child: Image.asset(AppImages.splashImage),
      ),
    );
  }
}
