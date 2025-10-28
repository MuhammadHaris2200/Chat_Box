// import 'dart:ui';
// import 'package:chat_box/constants/app_colors.dart';
// import 'package:chat_box/constants/app_icons.dart';
// import 'package:chat_box/constants/app_routes.dart';
// import 'package:chat_box/viewModel/provider/google_auth_provider.dart';
// import 'package:chat_box/viewModel/provider/signIn_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';

// class Flutter extends StatefulWidget {
//   const Flutter({super.key});
//   @override
//   State<Flutter> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<Flutter>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   String email = '', password = '';
//   bool obscure = true;
//   late AnimationController _aniController;
//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _aniController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _aniController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _onLogin() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() => _isLoading = true);

//       final signInProvider = context.read<SignInProvider>();
//       signInProvider.email = _emailController.text.trim();
//       signInProvider.password = _passwordController.text.trim();

//       try {
//         bool success = await signInProvider.signIn();
//         if (success && mounted) {
//           Navigator.pushReplacementNamed(context, AppRoutes.home);
//         }
//       } catch (e) {
//         Fluttertoast.showToast(
//           msg: e.toString(),
//           backgroundColor: AppColors.redColor,
//           textColor: AppColors.whiteColor,
//         );
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gradient background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(-0.8, -1),
//                 end: Alignment(1, 0.8),
//                 colors: [
//                   AppColors.purpleColor,
//                   AppColors.lightPurpleColor,
//                   AppColors.peachColor,
//                 ],
//                 stops: [0.0, 0.55, 1.0],
//               ),
//             ),
//           ),

//           // Decorative soft circles
//           Positioned(
//             top: -size.width * 0.25,
//             left: -size.width * 0.2,
//             child: AnimatedBuilder(
//               animation: _aniController,
//               builder: (_, __) {
//                 return Transform.scale(
//                   scale: 1 + 0.03 * (_aniController.value),
//                   child: _SoftCircle(150, Colors.white.withOpacity(0.06)),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             bottom: -size.width * 0.3,
//             right: -size.width * 0.25,
//             child: AnimatedBuilder(
//               animation: _aniController,
//               builder: (_, __) {
//                 return Transform.translate(
//                   offset: Offset(0, 8 * (_aniController.value - 0.5)),
//                   child: _SoftCircle(220, Colors.white.withOpacity(0.05)),
//                 );
//               },
//             ),
//           ),

//           // Center content
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // App icon + title
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const _AppLogo(),
//                       SizedBox(width: size.width * .03),
//                       Text(
//                         'Chatify',
//                         style: TextStyle(
//                           color: AppColors.whiteColor,
//                           fontSize: size.height * .034,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.6,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: size.height * .03),

//                   // Glass card
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//                       child: Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(size.height * .02),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: AppColors.white12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.black26,
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               // avatar
//                               CircleAvatar(
//                                 radius: size.height * .040,
//                                 backgroundImage: NetworkImage(
//                                   'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto='
//                                   'format&fit=crop&ixlib=rb-4.0.3&s=7c3a2f14a0b3b2b1a3f2a2d1b3c2a1f9',
//                                 ),
//                               ),
//                               SizedBox(height: size.height * .012),
//                               Text(
//                                 'Welcome Back',
//                                 style: TextStyle(
//                                   color: AppColors.whiteColor,
//                                   fontSize: size.height * .023,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: size.height * .019),

//                               // Email
//                               TextFormField(
//                                 style: TextStyle(color: AppColors.whiteColor),
//                                 decoration: _inputDecoration(
//                                   hint: 'Email...',
//                                   icon: AppIcons.cupertinoPersonIcon,
//                                 ),
//                                 keyboardType: TextInputType.emailAddress,
//                                 validator: (value) {
//                                   if (value == null || value.trim().isEmpty) {
//                                     return "Email is required";
//                                   }
//                                   if (!RegExp(
//                                     r'^[^@]+@[^@]+\.[^@]+',
//                                   ).hasMatch(value)) {
//                                     return "Enter a valid email";
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (v) => email = v?.trim() ?? '',
//                               ),

//                               SizedBox(height: size.height * .012),

//                               // Password
//                               TextFormField(
//                                 style: const TextStyle(
//                                   color: AppColors.whiteColor,
//                                 ),
//                                 obscureText: obscure,
//                                 decoration: _inputDecoration(
//                                   hint: 'Password',
//                                   icon: AppIcons.cupertinolLock,
//                                   suffix: IconButton(
//                                     onPressed: () =>
//                                         setState(() => obscure = !obscure),
//                                     icon: Icon(
//                                       obscure
//                                           ? AppIcons.materialVisibilityOff
//                                           : AppIcons.materialVisibility,
//                                       color: AppColors.white70,
//                                     ),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return "Password is required";
//                                   }
//                                   if (value.length > 6) {
//                                     return "Password must be atleast 8 characters";
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (v) => password = v ?? '',
//                               ),

//                               SizedBox(height: size.height * .01),

//                               // forgot + remember row
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(children: [
//                                     ],
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pushNamed(
//                                         context,
//                                         AppRoutes.forgot,
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Forgot?',
//                                       style: TextStyle(
//                                         color: AppColors.white70,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: size.height * .01),

//                               // Gradient login button
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: GestureDetector(
//                                   onTap: _onLogin,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: size.height * .014,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(12),
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           // Color(0xFF56CCF2),
//                                           AppColors.lightBlue,
//                                           AppColors.blueColor,
//                                         ],
//                                         begin: Alignment.centerLeft,
//                                         end: Alignment.centerRight,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           blurRadius: 2,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'Login',
//                                         style: TextStyle(
//                                           color: AppColors.whiteColor,
//                                           fontSize: size.height * .02,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: size.height * .02),

//                               // Or continue with
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Divider(color: AppColors.white24),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: size.width * .03,
//                                     ),
//                                     child: Text(
//                                       'OR',
//                                       style: TextStyle(
//                                         color: AppColors.white54,
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Divider(color: AppColors.white24),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: size.height * .015),

//                               // Social row
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   _SocialIcon(
//                                     icon: AppIcons.materialGoogle,
//                                     isLoading: _isLoading,
//                                     onTap: _isLoading
//                                         ? null
//                                         : () async {
//                                             setState(() => _isLoading = true);
//                                             try {
//                                               final googleProvider = context
//                                                   .read<GoogleAuthProvider>();
//                                               await googleProvider
//                                                   .signInWithGoogle();
//                                               if (mounted) {
//                                                 Navigator.pushReplacementNamed(
//                                                   context,
//                                                   AppRoutes.home,
//                                                 );
//                                               }
//                                             } catch (e) {
//                                               Fluttertoast.showToast(
//                                                 msg:
//                                                     "Google Sign-In failed: $e",
//                                                 backgroundColor:
//                                                     AppColors.redColor,
//                                                 textColor: AppColors.whiteColor,
//                                               );
//                                             } finally {
//                                               if (mounted) {
//                                                 setState(
//                                                   () => _isLoading = false,
//                                                 );
//                                               }
//                                             }
//                                           },
//                                   ),
//                                 ],
//                               ),

//                               SizedBox(height: size.height * .01),

//                               // Signup prompt
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Text(
//                                     'No account?',
//                                     style: TextStyle(color: AppColors.white70),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pushNamed(
//                                         context,
//                                         AppRoutes.signUp,
//                                       );
//                                     },
//                                     child: Text(
//                                       'Sign up',
//                                       style: TextStyle(
//                                         color: AppColors.blackColor,
//                                         fontSize: size.height * .018,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // small widgets below

// InputDecoration _inputDecoration({
//   required String hint,
//   required IconData icon,
//   Widget? suffix,
// }) {
//   return InputDecoration(
//     hintText: hint,
//     hintStyle: const TextStyle(color: AppColors.white70),
//     prefixIcon: Icon(icon, color: AppColors.white70),
//     suffixIcon: suffix,
//     filled: true,
//     fillColor: AppColors.white10,
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: AppColors.white12),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.white24),
//     ),
//   );
// }

// class _SoftCircle extends StatelessWidget {
//   final double size;
//   final Color color;
//   const _SoftCircle(this.size, this.color);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(shape: BoxShape.circle, color: color),
//     );
//   }
// }

// class _AppLogo extends StatelessWidget {
//   const _AppLogo();
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;
//     return Container(
//       width: 58,
//       height: 58,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: const LinearGradient(
//           colors: [AppColors.lightYellow, AppColors.darkPeach],
//         ),
//       ),
//       child: Icon(
//         AppIcons.materialChatBubble,
//         color: AppColors.whiteColor,
//         size: mq.height * .03,
//       ),
//     );
//   }
// }

// class _SocialIcon extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;
//   final bool isLoading;
//   const _SocialIcon({required this.icon, this.onTap, this.isLoading = false});
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: mq.height * .06,
//         height: mq.height * .06,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: AppColors.white10,
//           border: Border.all(color: AppColors.white12),
//         ),
//         child: isLoading
//             ? Padding(
//                 padding: EdgeInsets.all(mq.width * .025),
//                 child: Center(child: CircularProgressIndicator()),
//               )
//             : Icon(icon, color: AppColors.whiteColor, size: mq.width * .12),
//       ),
//     );
//   }
// }
