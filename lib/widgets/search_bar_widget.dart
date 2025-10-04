import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ///Media query intialization
    final mq = MediaQuery.of(context).size;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Search users",
        prefixIcon: Icon(AppIcons.materialSearchIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.height * .03),
        ),
        filled: true,
        fillColor: AppColors.lightGrey,
      ),
    );
  }
}
