import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _CallState();
}

class _CallState extends State<VideoCall> {
  String userId = DateTime.now().millisecondsSinceEpoch.toString();
  String userName = "Unknown";
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1952222276,
      appSign:
          "0e8689de7529e58c66ddf2fc0a3adb60c2d3578cc225f238c0a510b75d3ea19b",
      userID: userId,
      userName: userName,
      callID: "demo_call_id_for_testing",
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
