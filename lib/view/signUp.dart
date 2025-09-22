import 'package:chat_box/modelView/provider/signUp_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_routes.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  ///Controllers which initialize late
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;


  ///Init state
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }


  ///dispose
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

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
              child: TextFormField(
                controller: _nameController,
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
              child: TextFormField(
                controller: _emailController,
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
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            ///For space between text field of password and confirm password
            SizedBox(height: mq.height * .04),

            ///Confirm password text field
            SizedBox(
              width: mq.width * .87,
              child: TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            ///for space between text field of confirm password and sign up button
            SizedBox(height: mq.height * .20),


            ///Create an account button
            InkWell(
              onTap: () async {
                final signupProvider = Provider.of<SignupProvider>(
                  context,
                  listen: false,
                );

                signupProvider.name = _nameController.text.trim();
                signupProvider.email = _emailController.text.trim();
                signupProvider.password = _passwordController.text.trim();
                signupProvider.confirmPassword =
                    _confirmPasswordController.text.trim();

                try {
                  bool success = await signupProvider.signUp();
                  if (success) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
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
