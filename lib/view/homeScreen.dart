import 'package:chat_box/constants/app_colors.dart';
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
  TextEditingController _textEditingController = TextEditingController();

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
          height: mq.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: mq.width * .10,
                  height: mq.height * .02,
                  margin: EdgeInsets.only(bottom: mq.width * .05),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                "Your Chats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: mq.height * .03),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }
                    if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return const Center(child: Text("No chats found"));
                    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true),
    );
  }
}
