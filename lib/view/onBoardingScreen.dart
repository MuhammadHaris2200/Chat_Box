import 'package:chat_box/constants/app_colors.dart';
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
      ///body of onBoarding screen
      body: Stack(
        children: [
          ///Background Container of black and purple color mix
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blackColor,
                  AppColors.purpleColor,
                  AppColors.blackColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///ChatBox logo
                  Image.asset(
                    AppImages.onBoarding,
                    width: mq.width * .3,
                    height: mq.height * .15,
                  ),

                  ///Connect friends text
                  Padding(
                    padding: EdgeInsets.only(left: mq.width * .05),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Connect\n",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 60,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "friends\n",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 60,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "easily &\n",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 60,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: "quickly",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 60,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///for space between sub text and connect friend text
                  SizedBox(height: mq.height * .02),

                  ///Sub Text
                  Padding(
                    padding: EdgeInsets.only(left: mq.width * .05),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Our chat app is the perfect way to stay"
                        "\nconnected with friends and family.",
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ),
                  ),

                  ///Google Button
                  SizedBox(height: mq.height * .04),

                  ///Google Button
                  IconButton(
                    onPressed: () {
                      print("Google Button Clicked");
                    },
                    icon: Image.asset(
                      AppImages.onBoardingGoogleLogo,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),

                  ///for space between google button and OR text
                  SizedBox(height: mq.height * .02),

                  ///OR text
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mq.width * .05,
                          ),
                          child: Divider(
                            color: AppColors.white70,
                            thickness: 1,
                          ),
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mq.width * .05,
                          ),
                          child: Divider(
                            color: AppColors.white70,
                            thickness: 1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///for space between OR text and sign up with email text
                  SizedBox(height: mq.height * .03),

                  ///Container of sign up with email text
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/signUp");
                    },
                    child: Container(
                      width: mq.width * .8,
                      height: mq.height * .05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Sign up with email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///for space between sign up with email text and existing account text
                  SizedBox(height: mq.height * .03),

                  ///Existing account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Existing account??",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
