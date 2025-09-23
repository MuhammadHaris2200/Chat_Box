import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelView/provider/profile_provider.dart';

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
          ? CircularProgressIndicator()
          : Column(children: [SizedBox(height: 22), CircleAvatar()]),
    );
  }
}
