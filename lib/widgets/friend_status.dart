import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class FriendsStatusList extends StatelessWidget {
  const FriendsStatusList({super.key});

  final List<String> friends = const [
    "assets/images/friend1.png",
    "assets/images/friend2.png",
    "assets/images/friend3.png",
    "assets/images/friend4.png",
  ];

  @override
  Widget build(BuildContext context) {
    ///Initialization of media query
    final mq = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(10, (index) {
            return Padding(
              padding: EdgeInsets.only(left: mq.width * .05),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.whiteColor, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.whiteColor,
                      backgroundImage: AssetImage("assets/images/random.png"),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("User $index"),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
