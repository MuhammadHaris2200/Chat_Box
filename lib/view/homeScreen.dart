import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_images.dart';
import 'package:chat_box/widgets/my_status.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    ///App bar
    return Scaffold(
      backgroundColor: AppColors.blackColor, // Scaffold background black
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: mq.height * .01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.search, color: AppColors.whiteColor),

              // Center -> Home Text
              Text(
                "Home",
                style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
              ),

              // Right side -> Person Icon
              CircleAvatar(child: Image.asset(AppImages.randomImage)),
            ],
          ),
        ),
      ),

      ///Body
      body: Padding(
        padding: EdgeInsets.only(top: mq.height * .05),
        child: Row(
          children: [
            // 🔹 My Status (static)
            MyStatus(),

            // 🔹 Friends List (scrollable)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(10, (index) {
                    return Padding(
                      padding: EdgeInsets.only(left: mq.width * .05),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage(
                                "assets/images/random.png",
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
