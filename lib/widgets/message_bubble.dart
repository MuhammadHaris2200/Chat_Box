import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String opponentPic;
  final String opponentName;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.opponentPic,
    required this.opponentName,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (!isMe)
        //   Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.only(left: 12, right: 4),
        //         child: CircleAvatar(
        //           radius: 26,
        //           backgroundImage: opponentPic != ""
        //               ? NetworkImage(opponentPic)
        //               : null,
        //           child: opponentPic == ""
        //               ? Icon(
        //                   AppIcons.cupertinoPersonIcon,
        //                   size: 24,
        //                   color: Colors.white,
        //                 )
        //               : null,
        //         ),
        //       ),
        //     ],
        //   ),
        Flexible(
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // if (!isMe)
              //   Padding(
              //     padding: EdgeInsets.only(
              //       left: mq.width * .03,
              //       top: mq.height * .001,
              //     ),
              //     child: Text(
              //       opponentName,
              //       style: TextStyle(
              //         fontSize: mq.height * .024,
              //         color: AppColors.blackColor,
              //         //fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),

              /// Message bubble
              Padding(
                padding: EdgeInsets.only(
                  left: mq.width * .02,
                  top: mq.height * .003,
                  right: mq.width * .04
                ),
                child: Container(
                  //height: double.infinity,
                  //width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(
                    vertical: mq.height * .004,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.teal : AppColors.lightGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(18) : Radius.circular(0),
                      topRight: isMe ? Radius.circular(0) : Radius.circular(18),
                      bottomLeft: isMe
                          ? const Radius.circular(18)
                          : const Radius.circular(18),
                      bottomRight: isMe
                          ? const Radius.circular(18)
                          : const Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? AppColors.whiteColor : AppColors.blackColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
