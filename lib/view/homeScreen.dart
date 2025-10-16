import 'package:chat_box/add_status_screen.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/model/status_item_model.dart';
import 'package:chat_box/my_status_view_screen.dart';
import 'package:chat_box/services/login_authentication/email_password.dart';
import 'package:chat_box/services/my_service/friend_service.dart';
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

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";

    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

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
            child: FutureBuilder<List<String>>(
              future: FriendService().getFriendsList(),
              builder: (context, friendsSnap) {
                if (friendsSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final friendIds = friendsSnap.data ?? [];
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                final allUserIds = [
                  ...friendIds,
                  currentUserId,
                ]; // show friends + yourself

                if (allUserIds.isEmpty) {
                  return const Center(
                    child: Text(
                      'No statuses available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("statuses")
                      .where(FieldPath.documentId, whereIn: allUserIds)
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
                        // 👇 My Status (always first)
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
                                        .userHasStatus(currentUserId);
                                    if (hasStatus) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MyStatusViewScreen(
                                            userId: currentUserId,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddStatusScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  child: FutureBuilder<StatusItemModel?>(
                                    future: _statusService.getLatestStatus(
                                      currentUserId,
                                    ),
                                    builder: (context, s) {
                                      final latest = s.data;

                                      return CircleAvatar(
                                        radius: mq.width * .086,
                                        backgroundColor: latest == null
                                            ? AppColors.blueColor
                                            : AppColors.lightPurpleColor,
                                        child: latest == null
                                            ? const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: FittedBox(
                                                  child: Text(
                                                    (latest.text ?? '').length >
                                                            12
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

                        // 👇 Friends’ statuses
                        final doc = docs[index - 1];
                        final parentData = doc.data() as Map<String, dynamic>;
                        final userId = doc.id;
                        final userName = parentData["name"] ?? "User";
                        final profilePic = parentData["profilePic"] ?? "";

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mq.width * .02,
                            vertical: mq.height * .01,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // open status
                                },
                                child: FutureBuilder<StatusItemModel?>(
                                  future: _statusService.getLatestStatus(
                                    userId,
                                  ),
                                  builder: (context, snapLatest) {
                                    final latest = snapLatest.data;
                                    if (latest == null) {
                                      return CircleAvatar(
                                        radius: mq.width * .086,
                                        backgroundImage: profilePic.isNotEmpty
                                            ? NetworkImage(profilePic)
                                            : null,
                                        child: profilePic.isEmpty
                                            ? Text(
                                                userName[0].toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                ),
                                              )
                                            : null,
                                      );
                                    }

                                    if (latest.type == 'text') {
                                      return CircleAvatar(
                                        radius: mq.width * .086,
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FittedBox(
                                            child: Text(
                                              (latest.text ?? '').length > 12
                                                  ? '${latest.text!.substring(0, 12)}...'
                                                  : latest.text ?? '',
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
                                        backgroundImage: NetworkImage(
                                          latest.imageUrl!,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: mq.height * .01),
                              Text(
                                userName,
                                style: TextStyle(color: AppColors.whiteColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
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
