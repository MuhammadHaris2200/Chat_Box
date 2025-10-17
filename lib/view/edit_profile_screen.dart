import 'dart:convert';
import 'dart:io';
import 'package:chat_box/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;
  String? _profilePicUrl;

  final String cloudName = "dpvg9jrhc";
  final String uploadPreset = "rent_a_car";
  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data["name"] ?? '';
      _aboutController.text = data["about"] ?? '';
      _profilePicUrl = data["profilePic"];
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _pickedImage = File(picked.path);
      setState(() {});
    }
  }

  Future<String?> _uploadToCloudinary(File imageFile) async {
    try {
      final uploadUrl = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest("POST", uploadUrl)
        ..fields["upload_preset"] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final data = json.decode(resStr);
        return data["secure_url"];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cloudinary upload failed: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (e) {
      debugPrint("Cloudinary error: $e");
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
    });

    String? newImageUrl = _profilePicUrl;

    //upload to cloudinary if a new image selected
    if (_pickedImage != null) {
      newImageUrl = await _uploadToCloudinary(_pickedImage!);
    }
    //upload image path to firestore
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "name": _nameController.text.trim(),
      "about": _aboutController.text.trim(),
      "profilePic": newImageUrl,
    });
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile updated succesfully!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        title: Text("Edit profile"),
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(mq.width * .06),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (_profilePicUrl != null &&
                                  _profilePicUrl!.isNotEmpty)
                            ? NetworkImage(_profilePicUrl!) as ImageProvider
                            : null,
                        backgroundColor: AppColors.greyColor,
                        child:
                            _pickedImage == null &&
                                (_profilePicUrl == null &&
                                    _profilePicUrl!.isEmpty)
                            ? Icon(
                                AppIcons.materialCamera,
                                size: 30,
                                color: AppColors.whiteColor,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
