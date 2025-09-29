import 'package:chat_box/chat_screen.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/contacts_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = "";
//
//   String get currentUserId => FirebaseAuth.instance.currentUser!.uid;
//
//   void _onIconTap(int index) {
//     setState(() => _currentIndex = index);
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   /// BottomSheet → sirf latest chats
//   void _onMessagesTap() {
//   _onIconTap(0);
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) {
//       return Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // drag handle
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const Text(
//               "Your Chats",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//
//             // Chats list
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("chats")
//                     .where("participants", arrayContains: currentUserId)
//                     .orderBy("lastMessageTime", descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("No chats found"));
//                   }
//
//                   final chats = snapshot.data!.docs;
//
//                   return ListView.builder(
//                     itemCount: chats.length,
//                     itemBuilder: (context, index) {
//                       final chat = chats[index];
//                       final participants =
//                           List<String>.from(chat['participants']);
//                       final otherUserId = participants
//                           .firstWhere((id) => id != currentUserId);
//
//                       return FutureBuilder<DocumentSnapshot>(
//                         future: FirebaseFirestore.instance
//                             .collection("users")
//                             .doc(otherUserId)
//                             .get(),
//                         builder: (context, userSnap) {
//                           if (!userSnap.hasData) return const SizedBox();
//                           final userData =
//                               userSnap.data!.data() as Map<String, dynamic>;
//
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: userData['photoUrl'] != null
//                                   ? NetworkImage(userData['photoUrl'])
//                                   : null,
//                               child: userData['photoUrl'] == null
//                                   ? Icon(Icons.person, color: Colors.blue)
//                                   : null,
//                             ),
//                             title: Text(userData['name'] ?? "Unknown"),
//                             subtitle: Text(chat['lastMessage'] ?? ""),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => ChatScreen(
//                                     peerId: otherUserId,
//                                     peerName: userData['name'],
//                                     peerPhoto: userData['photoUrl'],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
//
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (val) {
//                 setState(() {
//                   searchQuery = val.trim();
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: "Search users...",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       body: searchQuery.isEmpty
//           ? PageView(
//               controller: _pageController,
//               onPageChanged: (i) => setState(() => _currentIndex = i),
//               children: const [
//                 Center(child: Text("Messages Page")),
//                 Center(child: Text("Calls Page")),
//                 Center(child: Text("Contacts Page")),
//                 Center(child: Text("Settings Page")),
//               ],
//             )
//           : _buildSearchResults(),
//
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           if (index == 0) {
//             _onMessagesTap();
//           } else {
//             _onIconTap(index);
//           }
//         },
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
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
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
//
//   /// Search bar ke liye results
//   Widget _buildSearchResults() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("users").snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No users found"));
//         }
//
//         final users = snapshot.data!.docs.where((doc) {
//           final name = (doc['name'] ?? "").toString().toLowerCase();
//           return name.contains(searchQuery.toLowerCase()) &&
//               doc.id != currentUserId;
//         }).toList();
//
//         if (users.isEmpty) {
//           return const Center(child: Text("No users found"));
//         }
//
//         return ListView.builder(
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.green[100],
//                 child: Icon(Icons.person, color: Colors.green),
//               ),
//               title: Text(user['name']),
//               onTap: () {},
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  void _onIconTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// BottomSheet → sirf latest chats
  void _onMessagesTap() {
    _onIconTap(0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Your Chats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Chats list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .where("participants", arrayContains: currentUserId)
                      .orderBy("lastMessageTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No chats found"));
                    }

                    final chats = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final participants =
                        List<String>.from(chat['participants']);
                        final otherUserId = participants
                            .firstWhere((id) => id != currentUserId);

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(otherUserId)
                              .get(),
                          builder: (context, userSnap) {
                            if (!userSnap.hasData) return const SizedBox();
                            final userData = userSnap.data!.data()
                            as Map<String, dynamic>;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                userData['photoUrl'] != null
                                    ? NetworkImage(userData['photoUrl'])
                                    : null,
                                child: userData['photoUrl'] == null
                                    ? const Icon(Icons.person,
                                    color: Colors.blue)
                                    : null,
                              ),
                              title: Text(userData['name'] ?? "Unknown"),
                              subtitle: Text(chat['lastMessage'] ?? ""),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(currentUserId: currentUserId, otherUserId: otherUserId)
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
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),

      body: searchQuery.isEmpty
          ? PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentIndex = i),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Search bar ke liye results
  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
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
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: const Icon(Icons.person, color: Colors.green),
              ),
              title: Text(user['name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      currentUserId: currentUserId,
                      otherUserId: user.id, // ✅ pass kar diya
                    ),
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


