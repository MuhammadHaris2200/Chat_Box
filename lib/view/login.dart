// import 'package:chat_box/constants/app_colors.dart';
// import 'package:chat_box/constants/app_images.dart';
// import 'package:chat_box/constants/app_routes.dart';
// import 'package:chat_box/viewModel/provider/google_auth_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide GoogleAuthProvider;
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// import '../viewModel/provider/signIn_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   ///Controllers which initialize late
//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;

//   ///Global form key for validation
//   final _formKey = GlobalKey<FormState>();

//   ///Password visibility state
//   bool _isPasswordVisible = false;

//   ///Init state
//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   ///dispose
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     ///Media query initialization
//     final mq = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ///For space
//               SizedBox(height: mq.height * .05),

//               ///Log in logo
//               Center(child: Image.asset(AppImages.loginPageLogo)),

//               ///For space between log in logo and text
//               SizedBox(height: mq.height * .03),

//               ///Text
//               Text(
//                 "Get chatting with friends and family today by\n       "
//                 "signing up for our chat app!",
//                 style: TextStyle(color: AppColors.greyColor),
//               ),

//               ///For space between text and google logo
//               SizedBox(height: mq.height * .03),

//               ///Google logo for google sign in
//               IconButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         setState(() {
//                           _isLoading = true;
//                         });
//                         final googleAuthProvider = context
//                             .read<GoogleAuthProvider>();
//                         try {
//                           await googleAuthProvider.signInWithGoogle();
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Signed in successfully"),
//                               behavior: SnackBarBehavior.floating,
//                               margin: EdgeInsets.all(16),
//                               shape: StadiumBorder(),
//                               backgroundColor: AppColors.blueColor,
//                             ),
//                           );
//                           Navigator.pushReplacementNamed(
//                             context,
//                             AppRoutes.home,
//                           );
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Error: $e"),
//                               behavior: SnackBarBehavior.floating,
//                               margin: const EdgeInsets.all(16),
//                               shape: StadiumBorder(),
//                               backgroundColor: AppColors.redColor,
//                             ),
//                           );
//                         } finally {
//                           setState(() {
//                             _isLoading = false;
//                           });
//                         }
//                       },
//                 icon: _isLoading
//                     ? SizedBox(
//                         height: 22,
//                         width: 22,
//                         child: CircularProgressIndicator(),
//                       )
//                     : Image.asset(AppImages.loginGoogleLogo),
//               ),

//               ///For space between google logo and OR text
//               SizedBox(height: mq.height * .03),

//               ///OR text in row widget
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: mq.width * .07),
//                       child: Divider(color: AppColors.lightGrey, thickness: 1),
//                     ),
//                   ),

//                   Text("OR", style: TextStyle(color: AppColors.greyColor)),

//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: mq.width * .07),
//                       child: Divider(color: AppColors.lightGrey, thickness: 1),
//                     ),
//                   ),
//                 ],
//               ),

//               ///For space between OR text and email text field
//               SizedBox(height: mq.height * .03),

//               ///Email text field
//               SizedBox(
//                 width: mq.width * .87,
//                 child: TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Email is required";
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                       return "Enter a valid email";
//                     }
//                     return null;
//                   },
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     hintText: "Your email",
//                     hintStyle: TextStyle(
//                       color: AppColors.teal,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),

//               ///For space between email text field and password text field
//               SizedBox(height: mq.height * .04),

//               ///Password text field
//               SizedBox(
//                 width: mq.width * .87,
//                 child: TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Password is required";
//                     }
//                     if (value.length > 6) {
//                       return "Password must be at least 6 characters";
//                     }
//                     return null;
//                   },
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: "Password",
//                     hintStyle: TextStyle(
//                       color: AppColors.teal,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: AppColors.blackColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               ///Forgot password in row widget
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, AppRoutes.forgot);
//                       },
//                       child: Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: AppColors.blackColor),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               ///For space between fields and log in button
//               SizedBox(height: mq.height * .12),

//               ///Log in button
//               InkWell(
//                 onTap: () async {
//                   ///Sign in provider ko initialize kiya
//                   final signInProvider = context.read<SignInProvider>();

//                   ///phir Sign in provider class k email or string ko controllers k through value di
//                   signInProvider.email = _emailController.text.trim();
//                   signInProvider.password = _passwordController.text.trim();

//                   try {
//                     ///phir yaha kaha k agr successfully login hojae user tw home page pe le jao
//                     bool success = await signInProvider.signIn();
//                     if (success) {
//                       // bool success = await signInProvider.signIn();
//                       // if (success) {
//                         // Initialize Zego Cloud after login
//                         ZegoUIKitPrebuiltCallInvitationService().init(
//                           appID: 1904149914, // e.g. 123456789
//                           appSign:
//                               "575027252986deab4d57d09ad2d261c1d3da24a8a0b4362004b0b533b64e66cf",
//                           userID: FirebaseAuth
//                               .instance
//                               .currentUser!
//                               .uid, // ya Firebase user.uid
//                           userName:
//                               FirebaseAuth.instance.currentUser!.displayName ??
//                               "Not Available",

//                           plugins: [ZegoUIKitSignalingPlugin()],
//                         );

//                         // Navigator.pushReplacementNamed(
//                         //   context,
//                         //   AppRoutes.bottomNavBar,
//                         // );
//                       // }

//                       Navigator.pushReplacementNamed(
//                         context,
//                         AppRoutes.bottomNavBar,
//                       );
//                     }
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: "msg",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.CENTER,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: AppColors.redColor,
//                       textColor: AppColors.whiteColor,
//                       fontSize: 16,
//                     );
//                   }
//                 },
//                 child: Container(
//                   width: mq.width * .8,
//                   height: mq.height * .05,
//                   decoration: BoxDecoration(
//                     color: AppColors.teal,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Log in",
//                       style: TextStyle(color: AppColors.whiteColor),
//                     ),
//                   ),
//                 ),
//               ),

//               ///Sign up button
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, AppRoutes.forgot);
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account?",
//                       style: TextStyle(color: AppColors.teal),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, AppRoutes.signUp);
//                       },
//                       child: Text(
//                         "Sign up",
//                         style: TextStyle(color: AppColors.blackColor),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_images.dart';
import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/viewModel/provider/google_auth_provider.dart';
import 'package:chat_box/viewModel/provider/signIn_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide GoogleAuthProvider;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ✅ Initialize Zego Cloud Calling Service after login
  Future<void> _initializeZego() async {
    final user = FirebaseAuth.instance.currentUser!;
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1904149914, // 🔹 Your Zego App ID
      appSign:
          "575027252986deab4d57d09ad2d261c1d3da24a8a0b4362004b0b533b64e66cf", // 🔹 Your App Sign
      userID: user.uid,
      userName: user.displayName ?? user.email ?? "User",
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  /// 🔹 Email & Password login
  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final signInProvider = context.read<SignInProvider>();
    signInProvider.email = _emailController.text.trim();
    signInProvider.password = _passwordController.text.trim();

    setState(() => _isLoading = true);
    try {
      bool success = await signInProvider.signIn();
      if (success) {
        // await _initializeZego(); // ✅ Initialize after successful login
          await ZegoUIKitPrebuiltCallInvitationService().init(
    appID: 1904149914,
    appSign: "575027252986deab4d57d09ad2d261c1d3da24a8a0b4362004b0b533b64e66cf",
    userID: FirebaseAuth.instance.currentUser!.uid,
    userName: FirebaseAuth.instance.currentUser!.email ?? "User",
    plugins: [ZegoUIKitSignalingPlugin()],
  );
  // Fluttertoast.showToast(msg: "Login successful!");
  // Navigator.pushReplacementNamed(context, AppRoutes.bottomNavBar);
        Fluttertoast.showToast(msg: "Login successful!");
        Navigator.pushReplacementNamed(context, AppRoutes.bottomNavBar);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed: $e",
        backgroundColor: AppColors.redColor,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Google login
  Future<void> _handleGoogleLogin(BuildContext context) async {
    final googleAuthProvider = context.read<GoogleAuthProvider>();

    setState(() => _isLoading = true);
    try {
      await googleAuthProvider.signInWithGoogle();
      await _initializeZego();
      Fluttertoast.showToast(msg: "Google Sign-in successful!");
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Google Sign-in failed: $e",
        backgroundColor: AppColors.redColor,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: mq.height * .05),
              Image.asset(AppImages.loginPageLogo, height: mq.height * 0.25),
              const SizedBox(height: 10),
              Text(
                "Chat with friends & family — sign in below!",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.greyColor),
              ),
              SizedBox(height: mq.height * .03),

              /// 🔹 Google login button
              _isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: Image.asset(AppImages.loginGoogleLogo, height: 30),
                      onPressed: () => _handleGoogleLogin(context),
                    ),

              SizedBox(height: mq.height * .03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(color: AppColors.lightGrey, thickness: 1),
                  ),
                  const Text("  OR  "),
                  Expanded(
                    child: Divider(color: AppColors.lightGrey, thickness: 1),
                  ),
                ],
              ),
              SizedBox(height: mq.height * .03),

              /// 🔹 Email
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email required";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: mq.height * .03),

              /// 🔹 Password
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Password required";
                  if (value.length < 6)
                    return "At least 6 characters required";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.forgot),
                  child: const Text("Forgot Password?"),
                ),
              ),

              SizedBox(height: mq.height * .08),

              /// 🔹 Login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  minimumSize: Size(mq.width * .8, mq.height * .055),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : () => _handleLogin(context),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Log in",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 15),

              /// 🔹 Sign up navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.signUp),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
