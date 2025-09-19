import 'package:flutter/material.dart';

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
    return SizedBox(
      height: 100, // status circle ki height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(friends[index]),
                ),
                const SizedBox(height: 5),
                Text("Friend ${index + 1}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
