import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_images.dart';
import 'package:chat_box/constants/app_routes.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  @override
  Widget build(BuildContext context) {
    ///Media query initialization
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
              "Get chatting with friends and family today by\n       "
              "signing up for our chat app!",
              style: TextStyle(color: AppColors.greyColor),
            ),

            SizedBox(height: mq.height * .03),

            IconButton(
              onPressed: () {},
              icon: Image.asset(AppImages.loginGoogleLogo),
            ),

            SizedBox(height: mq.height * .03),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .07),
                    child: Divider(color: AppColors.lightGrey, thickness: 1),
                  ),
                ),
                Text("OR", style: TextStyle(color: AppColors.greyColor)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .07),
                    child: Divider(color: AppColors.lightGrey, thickness: 1),
                  ),
                ),
              ],
            ),

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

            SizedBox(height: mq.height * .20),

            Container(
              width: mq.width * .8,
              height: mq.height * .05,
              decoration: BoxDecoration(
                color: AppColors.teal,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "Log in",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ),


            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.forgot);
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: AppColors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
