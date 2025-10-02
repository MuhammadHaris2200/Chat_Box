import 'package:chat_box/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const MessageBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: mq.width * .02,
          vertical: mq.height * .005,
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isMe ? AppColors.blueColor : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: mq.height * .02,
            color: isMe ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
