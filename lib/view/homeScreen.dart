import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:chat_box/view/chat_screen.dart';
import 'package:chat_box/widgets/chats_bottom_sheet.dart';
import 'package:chat_box/widgets/search_results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///initially empty
  String searchQuery = '';

  ///Current user
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: mq.height * .01),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: AppColors.whiteColor,
            ),
          ),
        ),

        title: _isSearching
            ? TextField(
                autofocus: true,
                style: TextStyle(color: AppColors.whiteColor),
                decoration: InputDecoration(
                  hintText: "Search users...",
                  hintStyle: TextStyle(color: AppColors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.greyColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.whiteColor),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
              )
            : Center(
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(mq.height * .05),
          child: SizedBox(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: mq.width * .04,
              top: mq.height * .01,
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
          ),
        ],
      ),
      body: Column(
        ///users status
        children: [
          SizedBox(
            height: mq.height * .17,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .02,
                    vertical: mq.height * .01,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.blueColor,
                        radius: mq.width * .086,
                        child: Icon(AppIcons.cupertinoPersonIcon),
                      ),

                      SizedBox(height: mq.height * .01),

                      Flexible(
                        child: Text(
                          "User $index",
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          ///Recent chats
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(mq.height * .05),
              ),

              ///custom widgets of showing recent chats
              child: searchQuery.isEmpty
                  ? RecentChats(currentUserId: currentUserId)
                  : SearchResultsList(
                      searchQuery: searchQuery,
                      currentUserId: currentUserId,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
