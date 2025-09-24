import 'package:chat_box/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final user = profileProvider.user;
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Screen"), centerTitle: true),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 22),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.profilePic.isNotEmpty
                      ? NetworkImage(user.profilePic)
                      : null,
                  child: user.profilePic.isEmpty
                      ? Icon(AppIcons.cupertinoPersonIcon)
                      : null,
                ),
                SizedBox(height: 20),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(user.email),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // profileProvider.updateProfilePic(user.profilePic);
                  },
                  child: Text("Update"),
                ),
              ],
            ),
    );
  }
}
