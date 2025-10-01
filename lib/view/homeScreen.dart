import 'package:chat_box/chat_screen.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
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
  int _currentIndex = 0;

  ///controller for searching current users
  final TextEditingController _searchController = TextEditingController();

  ///initially empty
  String searchQuery = '';

  ///Current user
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  ///is func se icon ka pata chl k us page pe chla jaega user
  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onMessagesTap() {
    final mq = MediaQuery.of(context).size;
    _onIconTap(0);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        ///yaha kaha k firestore se chats collection ma se jo participants
        ///name ki list ha us ma se jo current user ha uski recent chats de do
        final stream = FirebaseFirestore.instance
            .collection("chats")
            .where("participants", arrayContains: currentUserId)
            .orderBy("lastMessage", descending: true)
            .snapshots();

        return Container(
          color: AppColors.lightGrey,
          height: mq.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Text(
                    "Your Chats",
                    style: TextStyle(
                      fontSize: mq.height * .03,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: mq.height * .03),

              Expanded(
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
                        ///sara chat document chat variable ma
                        final chat = chats[index];

                        ///then participants name ki list jis ma do users jo aik
                        ///dosre se chat krenge unki list is participant ma store
                        ///hoti ha is liye us list ko string ma store kr k safe bana diya
                        final participants = List<String>.from(
                          chat['participants'],
                        );

                        ///yaha condition lagayi k current user id k ilava baqi
                        ///sb users jo app k andr exist krte ha unki id chahiye
                        final otherUserId = participants.firstWhere((id) {
                          return id != currentUserId;
                        });

                        ///phir yaha users ka data firestore se get kr rhe ha future ma
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(otherUserId)
                              .get(),
                          builder: (context, userSnapshot) {
                            ///if data not exist return sized box
                            if (!userSnapshot.hasData) return const SizedBox();

                            ///phir yaha jo data aya ha users ka usko
                            ///map<string,dynamic> ma show krdiya
                            final userData =
                                userSnapshot.data!.data()
                                    as Map<String, dynamic>;

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
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                    ),
                                  );
                                },
                              ),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return ChatScreen(
                                        currentUserId: currentUserId,
                                        otherUserId: otherUserId,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(mq.height * .07),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: "Search users",
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(AppIcons.materialSearchIcon),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
              ),
            ),
          ),
        ),
      ),

      body: searchQuery.isEmpty
          ? PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              children: const [
                Center(child: Text("Messages Page")),
                Center(child: Text("Calls Page")),
                Center(child: Text("Contacts Page")),
                Center(child: Text("Settings Page")),
              ],
            )
          : _buildSearchResults(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            _onMessagesTap();
          } else {
            _onIconTap(index);
          }
        },
        selectedItemColor: AppColors.blueColor,
        unselectedItemColor: AppColors.blackColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.materialMessageIcon),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.cupertinoCallIcon),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.cupertinoContacts),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.cupertinoSettings),
            label: "Settings",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  ///ye aik apna custom widget banaya ha jis ki help
  ///search filed ma users ko search kr k dekh skhenge
  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No users found");
        }

        final users = snapshot.data!.docs.where((doc) {
          final name = (doc['name'] ?? "").toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) &&
              doc.id != currentUserId;
        }).toList();
        if (users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.builder( 
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return ListTile(
              leading: CircleAvatar(child: Icon(AppIcons.cupertinoPersonIcon)),
              title: Text(
                user["name"],
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(ChatService.chatId(currentUserId, user.id))
                    .collection("messages")
                    .orderBy("timestamp", descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No messages yet!!");
                  }

                  final lastMessage = snapshot.data!.docs.first;
                  return Text(
                    lastMessage['text'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.greenColor),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ChatScreen(
                        currentUserId: currentUserId,
                        otherUserId: user.id,
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
