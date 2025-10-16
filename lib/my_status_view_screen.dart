import 'dart:developer';

import 'package:chat_box/add_status_screen.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/status_service.dart';
import 'package:flutter/material.dart';

class MyStatusViewScreen extends StatelessWidget {
  final String userId;
  const MyStatusViewScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return AddStatusScreen();
              },
            ),
          );
        },
        backgroundColor: AppColors.peachColor,
        child: Icon(AppIcons.materialEdit, color: AppColors.blackColor),
      ),
      body: FutureBuilder(
        future: StatusService().getUserStatuses(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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
          return PageView.builder(
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              log(statuses.length.toString());
              return Center(
                child: Text(
                  status.text ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 24),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
