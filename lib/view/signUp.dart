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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: mq.height * .05),
            Center(child: Image.asset(AppImages.loginPageLogo)),
            SizedBox(height: mq.height * .03),
            Text(
              "Welcome back! Sign in using your social\n       "
                  "account or email to continue us",
              style: TextStyle(color: AppColors.greyColor),
            ),

            // SizedBox(height: mq.height * .03),
            //
            // IconButton(
            //   onPressed: () {},
            //   icon: Image.asset(AppImages.loginGoogleLogo),
            // ),

            SizedBox(height: mq.height * .03),

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

            SizedBox(height: mq.height * .04),

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

            SizedBox(height: mq.height * .04),

            SizedBox(
              width: mq.width * .87,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),
            ),

            SizedBox(height: mq.height * .04),

            SizedBox(
              width: mq.width * .87,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),
            ),


            SizedBox(
              height: mq.height * .20,
            ),

            Container(
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
          ],
        ),
      ),
    );
  }
}
