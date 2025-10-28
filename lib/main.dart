import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:chat_box/services/my_service/profile_service.dart';
import 'package:chat_box/utils/app_pages.dart';
import 'package:chat_box/viewModel/provider/chat_service_provider.dart';
import 'package:chat_box/viewModel/provider/forgot_provider.dart';
import 'package:chat_box/viewModel/provider/google_auth_provider.dart';
import 'package:chat_box/viewModel/provider/profile_provider.dart';
import 'package:chat_box/viewModel/provider/signIn_provider.dart';
import 'package:chat_box/viewModel/provider/signUp_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide GoogleAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   /// ✅ Zego Call Kit Navigator Setup
//   ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

//   /// ✅ System Calling UI Setup (once at app start)
//   await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
//     [ZegoUIKitSignalingPlugin()],
//   );

//   final authService = EmailPassword();
//   final profileService = ProfileService();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => SignupProvider(authService)),
//         ChangeNotifierProvider(create: (_) => SignInProvider(authService)),
//         ChangeNotifierProvider(create: (_) => ForgotProvider(authService)),
//         ChangeNotifierProvider(create: (_) => ProfileProvider(profileService)),
//         ChangeNotifierProvider(create: (_) => GoogleAuthProvider()),
//         ChangeNotifierProvider(create: (_) => ChatServiceProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final auth = FirebaseAuth.instance;
  final currentUser = auth.currentUser;

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
    ZegoUIKitSignalingPlugin(),
  ]);

  if (currentUser != null) {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1904149914,
      appSign:
          "575027252986deab4d57d09ad2d261c1d3da24a8a0b4362004b0b533b64e66cf",
      userID: currentUser.uid,
      userName: currentUser.displayName ?? currentUser.email ?? "User",
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  final authService = EmailPassword();
  final profileService = ProfileService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider(authService)),
        ChangeNotifierProvider(create: (_) => SignInProvider(authService)),
        ChangeNotifierProvider(create: (_) => ForgotProvider(authService)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(profileService)),
        ChangeNotifierProvider(create: (_) => GoogleAuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatServiceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "Chat Box",
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppPages.getRoutes(),
    );
  }
}
