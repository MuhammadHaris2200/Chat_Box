import 'package:chat_box/constants/app_images.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.purple,
                    Colors.black, // beech me purple, dono side black
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(AppImages.onBoarding,width: mq.width * .3,height: mq.height * .15),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(left: mq.width * .05),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Onboarding Screen",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
