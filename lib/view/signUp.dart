import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_routes.dart';
import '../viewModel/provider/signUp_provider.dart';

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

  ///Global form key for validation
  final _formKey = GlobalKey<FormState>();

  ///Password visibility state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///Initialization of media query
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),

      ///Body
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.blackColor,
                      ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    hintStyle: TextStyle(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ),

              ///for space between text field of
              ///confirm password and sign up button
              SizedBox(height: mq.height * .20),

              ///Create an account button
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final signupProvider = context.read<SignupProvider>();

                    signupProvider.name = _nameController.text.trim();
                    signupProvider.email = _emailController.text.trim();
                    signupProvider.password = _passwordController.text.trim();
                    signupProvider.confirmPassword = _confirmPasswordController
                        .text
                        .trim();

                    try {
                      bool success = await signupProvider.signUp();
                      if (success) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    } catch (e) {
                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text(e.toString()))); 
                    }
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
      ),
    );
  }
}
