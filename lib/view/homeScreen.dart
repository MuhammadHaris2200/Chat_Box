import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:chat_box/view/chat_screen.dart';
import 'package:chat_box/widgets/search_results.dart';
import 'package:chat_box/widgets/chats_bottom_sheet.dart';
import 'package:chat_box/widgets/search_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///Page controller for control page view icons
  final PageController _pageController = PageController();

  ///current index of page view is equal to 0
  //int _currentIndex = 0;

  ///controller for searching current users
  final TextEditingController _searchController = TextEditingController();

  ///initially empty
  String searchQuery = '';

  ///Current user
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  ///jb page view k icons pe tap krenge tw is func se
  ///value change hogi jis se icons bhi change honge
  // void _onIconTap(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   _pageController.animateToPage(
  //     index,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  ///Page view k message icon pe tap krne se ye
  ///func call hoga jis se recent chat show hojaegi
  // void _onMessagesTap() {
  //   _onIconTap(0);

  // showModalBottomSheet(
  //   context: context,
  //   shape: StadiumBorder(),
  //   isScrollControlled: true,
  //   builder: (context) => ChatsBottomSheet(currentUserId: currentUserId),
  // );
  //}

  ///dispose func ma controllers ko call
  ///kiya ha takay memory leak na ho
  // @override
  // void dispose() {
  //   super.dispose();
  //   _pageController.dispose();
  //   _searchController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    final stream = FirebaseFirestore.instance
        .collection("chats")
        .where("participants", arrayContains: currentUserId)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: AppColors.blackColor,

      // appBar: AppBar(
      //   title: const Text("Home"),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(mq.height * .07),

      //     ///custom widget (search bar widget)
      //     child: SearchBarWidget(
      //       controller: _searchController,
      //       onChanged: (v) => setState(() => searchQuery = v.trim()),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(AppIcons.cupertinoSearchIcon, color: AppColors.whiteColor),
        ),
        title: Center(
          child: Text("Home", style: TextStyle(color: AppColors.whiteColor)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(mq.height * .05),
          child: SizedBox(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/300", // 👈 abhi random image
              ),
            ),
          ),
        ],
      ),
      body: Column(
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
                    vertical: mq.height * .03,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.blueColor,
                        radius: mq.width * .086,
                        child: Icon(AppIcons.cupertinoPersonIcon),
                      ),

                      SizedBox(height: mq.height * .01),

                      Text(
                        "User $index",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(mq.width * .15),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No chats found"));
                  }

                  final chats = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final participants = List<String>.from(
                        chat['participants'],
                      );

                      final otherUserId = participants.firstWhere(
                        (id) => id != currentUserId,
                      );

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(otherUserId)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) return const SizedBox();

                          final userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: userData['photoUrl'] != null
                                  ? NetworkImage(userData['photoUrl'])
                                  : null,
                              child: userData['photoUrl'] == null
                                  ? Icon(AppIcons.cupertinoPersonIcon)
                                  : null,
                            ),
                            title: Text(userData['name'] ?? "Unknown"),
                            subtitle: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("chats")
                                  .doc(
                                    ChatService.chatId(
                                      currentUserId,
                                      otherUserId,
                                    ),
                                  )
                                  .collection("messages")
                                  .orderBy("timestamp", descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Text("No messages yet");
                                }

                                final lastMessage = snapshot.data!.docs.first;
                                return Text(
                                  lastMessage["text"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.greyColor),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    currentUserId: currentUserId,
                                    otherUserId: otherUserId,
                                  ),
                                ),
                              );
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: AppColors.blackColor,
      //   selectedItemColor: AppColors.blueColor,
      //   unselectedItemColor: AppColors.greyColor,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(AppIcons.cupertinoMessageCall)),
      //   ],
      // ),
      // searchQuery.isEmpty
      //     ? PageView(
      //         controller: _pageController,
      //         onPageChanged: (value) {
      //           setState(() {
      //             _currentIndex = value;
      //           });
      //         },
      //         children: const [
      //           Center(child: Text("Messages Page")),
      //           Center(child: Text("Calls Page")),
      //           Center(child: Text("Contacts Page")),
      //           Center(child: Text("Settings Page")),
      //         ],
      //       )
      //     ///custom widget for users search
      //     : SearchResultsList(
      //         searchQuery: searchQuery,
      //         currentUserId: currentUserId,
      //       ),

      // ///bottom navigation bar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     if (index == 0) {
      //       _onMessagesTap();
      //     } else {
      //       _onIconTap(index);
      //     }
      //   },
      //   selectedItemColor: AppColors.blueColor,
      //   unselectedItemColor: AppColors.blackColor,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(AppIcons.materialMessageIcon),
      //       label: "Messages",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(AppIcons.cupertinoCallIcon),
      //       label: "Calls",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(AppIcons.cupertinoContacts),
      //       label: "Contacts",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(AppIcons.cupertinoSettings),
      //       label: "Settings",
      //     ),
      //   ],
      //   type: BottomNavigationBarType.fixed,
      // ),
    );
  }
}

//tyefcbhjn
// class HomeScreen extends StatefulWidget {
//   final String currentUserId;

//   const HomeScreen({super.key, required this.currentUserId});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.black, // dark theme like design
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: const Text("Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.search, color: Colors.white),
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           /// Top Stories Row
//           SizedBox(
//             height: mq.height * 0.20,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 10, // dummy stories
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 48),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.grey.shade800,
//                           child: const Icon(Icons.person, color: Colors.white),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "User $index",
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           /// Recent Chats
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 child: ListView.builder(
//                   itemCount: 15, // dummy chats
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: const CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.blue,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       title: const Text(
//                         "Alex Linderson",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       subtitle: const Text(
//                         "How are you today?",
//                         style: TextStyle(color: Colors.grey),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       trailing: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "2 min ago",
//                             style: TextStyle(
//                               color: Colors.white60,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: const BoxDecoration(
//                               color: Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Text(
//                               "2",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         // Navigate to chat screen
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),

//       /// Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
//           BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.contacts),
//             label: "Contacts",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: "Settings",
//           ),
//         ],
//       ),
//     );
//   }
// }
