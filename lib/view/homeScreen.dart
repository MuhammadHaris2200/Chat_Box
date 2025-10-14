import 'package:chat_box/add_status_screen.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/constants/app_routes.dart';
import 'package:chat_box/model/status_item_model.dart';
import 'package:chat_box/my_status_view_screen.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:chat_box/services/my_service/status_service.dart';
import 'package:chat_box/widgets/recent_chats.dart';
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
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  bool _isSearching = false;

  final StatusService _statusService = StatusService();

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
            child: InkWell(
              onTap: () async {
                await EmailPassword().logOut();
                // Navigator.
              },
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        ///users status
        children: [
          //for status
          SizedBox(
            height: mq.height * .17,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("statuses")
                  .where("hasStatus", isEqualTo: true)
                  .orderBy("lastUpdated", descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? [];

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length + 1,
                  itemBuilder: (context, index) {
                    //my status always shown
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * .02,
                          vertical: mq.height * .01,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final hasStatus = await StatusService()
                                    .userHasStatus(currentUserId!);
                                if (hasStatus) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return MyStatusViewScreen(
                                          userId: currentUserId!,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return AddStatusScreen();
                                      },
                                    ),
                                  );
                                }
                              },
                              child: FutureBuilder<StatusItemModel?>(
                                future: _statusService.getLatestStatus(
                                  currentUserId ?? '',
                                ),
                                builder: (context, s) {
                                  final latest = s.data;

                                  // if user has a latest text status, show preview, else show + icon
                                  return CircleAvatar(
                                    radius: mq.width * .086,
                                    backgroundColor: latest == null
                                        ? AppColors.blueColor
                                        : AppColors
                                              .lightPurpleColor, // pick color
                                    child: latest == null
                                        ? const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 28,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FittedBox(
                                              child: Text(
                                                (latest.text ?? '').length > 12
                                                    ? '${(latest.text ?? '').substring(0, 12)}...'
                                                    : (latest.text ?? ''),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: mq.height * .01),
                            Text(
                              "My status",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      );
                    }
                    final doc = docs[index - 1];
                    final parentData = doc.data() as Map<String, dynamic>;
                    final userId = doc.id;
                    final userName = parentData["name"] ?? "User";

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width * .02,
                        vertical: mq.height * .01,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {},
                            child: FutureBuilder<StatusItemModel?>(
                              future: _statusService.getLatestStatus(userId),
                              builder: (context, snapLatest) {
                                if (snapLatest.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircleAvatar(
                                    radius: mq.width * .086,
                                    backgroundColor: AppColors.greyColor,
                                  );
                                }
                                final latest = snapLatest.data;
                                if (latest == null) {
                                  final profilePic =
                                      parentData['profilePic'] as String? ?? '';
                                  return CircleAvatar(
                                    radius: mq.width * .086,
                                    backgroundImage: profilePic.isNotEmpty
                                        ? NetworkImage(profilePic)
                                        : null,
                                    child: profilePic.isEmpty
                                        ? Icon(AppIcons.cupertinoPersonIcon)
                                        : null,
                                  );
                                }
                                if (latest.type == 'text') {
                                  final preview = (latest.text ?? '');
                                  return CircleAvatar(
                                    radius: mq.width * .086,
                                    backgroundColor: Colors.deepPurpleAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FittedBox(
                                        child: Text(
                                          preview.length > 12
                                              ? '${preview.substring(0, 12)}...'
                                              : preview,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: mq.width * .086,
                                    backgroundImage: latest.imageUrl != null
                                        ? NetworkImage(latest.imageUrl!)
                                        : null,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: mq.height * .01),
                          SizedBox(
                            width: mq.width * .18,
                            child: Text(
                              userName,
                              style: TextStyle(color: AppColors.whiteColor),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mq.height * .05),
                  topRight: Radius.circular(mq.height * .05),
                ),
              ),

              ///custom widgets of showing recent chats
              child: searchQuery.isEmpty
                  ? RecentChats(currentUserId: currentUserId ?? '')
                  : SearchResultsList(
                      searchQuery: searchQuery,
                      currentUserId: currentUserId ?? '',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
