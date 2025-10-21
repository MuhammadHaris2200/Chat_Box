import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/view/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.greyColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.cupertinoLogOut,
              color: AppColors.redColor,
              size: mq.width * .08,
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final userDoc = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.1,
              vertical: mq.height * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: mq.height * .09,
                  backgroundColor: AppColors.greyColor,
                  backgroundImage:
                      userDoc['profilePic'] != null &&
                          userDoc['profilePic'].toString().isNotEmpty
                      ? NetworkImage(userDoc["profilePic"])
                      : null,
                  child:
                      (userDoc["profilePic"] == null ||
                          userDoc["profilePic"].toString().isEmpty)
                      ? Text(
                          userDoc["name"] != null
                              ? userDoc["name"][0].toUpperCase()
                              : "?",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: mq.height * .07,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 20),

                Text(
                  userDoc['name'] ?? "No name",
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  userDoc['email'] ?? user!.email ?? '',
                  style: const TextStyle(
                    color: AppColors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  userDoc['about'] ?? "Hey there! I'm using ChatBox",
                  style: const TextStyle(
                    color: AppColors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 14,
                    ),
                  ),
                  icon: Icon(
                    AppIcons.materialEdit,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  label: const Text(
                    "Edit Profile",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
