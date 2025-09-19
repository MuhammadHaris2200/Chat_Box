import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_routes.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    ///Initialization of media query
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),

      ///Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///For space
            SizedBox(height: mq.height * .05),

            ///Logo of sign up with email
            Center(child: Image.asset(AppImages.signUpPageLogo)),

            ///For space between logo and text
            SizedBox(height: mq.height * .03),

            ///Text
            Text(
              "Welcome back! Sign in using your social\n       "
              "account or email to continue us",
              style: TextStyle(color: AppColors.greyColor),
            ),

            ///For space between text and text fields
            SizedBox(height: mq.height * .03),

            ///Text field of name
            SizedBox(
              width: mq.width * .87,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Your name",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            ///For space between text field of email and text field of password
            SizedBox(height: mq.height * .04),

            ///Text field of password
            SizedBox(
              width: mq.width * .87,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Your email",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            ///For space between text field of email and text field of password
            SizedBox(height: mq.height * .04),

            ///Text field of password
            SizedBox(
              width: mq.width * .87,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            ///For space between text field of confirm password and confirm password
            SizedBox(height: mq.height * .04),

            ///Te
            SizedBox(
              width: mq.width * .87,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(height: mq.height * .20),

            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              child: Container(
                width: mq.width * .8,
                height: mq.height * .05,
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Create an account",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
