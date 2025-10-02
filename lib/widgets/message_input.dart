import 'package:chat_box/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * .02,
        vertical: mq.height * .05,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02,
                vertical: mq.width * .01,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_emotions, color: AppColors.greyColor),
                  SizedBox(width: mq.width * .01),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.attach_file, color: AppColors.greyColor),
                ],
              ),
            ),
          ),
          SizedBox(width: mq.width * .02),
          CircleAvatar(
            radius: mq.height * .028,
            backgroundColor: AppColors.greyColor,
            child: IconButton(
              icon: Icon(Icons.send, color: AppColors.blackColor),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
