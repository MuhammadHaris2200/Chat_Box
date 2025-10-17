import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:chat_box/view/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      setState(() {
        userData = doc.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    if (userData == null) {
      return const Scaffold(
        backgroundColor: AppColors.blackColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.black26,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.greyColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.cupertinoLogOut,
              color: AppColors.redColor,
              size: mq.width * .1,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: EdgeInsets.all(mq.width * 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: mq.height * .09,
                  backgroundColor: AppColors.greyColor,
                  backgroundImage:
                      userData!['profilePic'] != null &&
                          userData!['profilePic'].toString().isNotEmpty
                      ? NetworkImage(userData!["profilePic"])
                      : null,
                  child:
                      (userData!["profilePic"] == null ||
                          userData!["profilePic"].toString().isEmpty)
                      ? Text(
                          userData!["name"] != null
                              ? userData!["name"][0].toUpperCase()
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
                  userData!['name'] ?? "Np name",
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  userData!['email'] ?? user!.email ?? '',
                  style: const TextStyle(
                    color: AppColors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  userData!['about'] ?? "Hey there! I'm using ChatBox",
                  style: TextStyle(color: AppColors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    AppIcons.materialEdit,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () {
                    //AppRoutes.profileEditScreen;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return EditProfileScreen();
                        },
                      ),
                    );
                  },
                  label: const Text("Edit profile"),
                ),

                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
