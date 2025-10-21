import 'package:chat_box/bottom_nav_bar.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/services/my_service/status_service.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class MyStatusViewScreen extends StatefulWidget {
  final String userId;
  const MyStatusViewScreen({super.key, required this.userId});

  @override
  State<MyStatusViewScreen> createState() => _MyStatusViewScreenState();
}

class _MyStatusViewScreenState extends State<MyStatusViewScreen> {
  final StoryController _storyController = StoryController();

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: const Text(
          "My Status",
          style: TextStyle(color: AppColors.blackColor),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: StatusService().getUserStatuses(widget.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final statuses = snapshot.data!;
          if (statuses.isEmpty) {
            return const Center(
              child: Text(
                "You haven't posted any status yet!",
                style: TextStyle(color: AppColors.white70),
              ),
            );
          }

          // Convert statuses into StoryItems (text/image/video)
          final storyItems = statuses.map((status) {
            if (status.imageUrl != null && status.imageUrl!.isNotEmpty) {
              return StoryItem.pageImage(
                url: status.imageUrl!,
                controller: _storyController,
              );
            } else {
              return StoryItem.text(
                title: status.text ?? '',
                backgroundColor: AppColors.peachColor,
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: AppColors.blackColor,
                ),
              );
            }
          }).toList();

          return StoryView(
            storyItems: storyItems,
            controller: _storyController,
            onComplete: () {
              Navigator.pop(context);
              BottomNavBar();
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }
}
