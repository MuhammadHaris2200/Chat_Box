import 'package:chat_box/chat_screen.dart';
import 'package:chat_box/view/groupCall.dart';
import 'package:chat_box/view/homeScreen.dart';
import 'package:flutter/material.dart';

// class ContactsBottomSheet extends StatelessWidget {
//   final List<Map<String, String>> dummyContacts = [
//     {"name": "Ali Khan", "photoUrl": ""},
//     {"name": "Haris Arif", "photoUrl": ""},
//     {"name": "Ayesha Noor", "photoUrl": ""},
//     {"name": "Ahmed Raza", "photoUrl": ""},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       height: MediaQuery.of(context).size.height * 0.6,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // top indicator
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),

//           Text(
//             "Your Contacts",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 12),

//           Expanded(
//             child: ListView.builder(
//               itemCount: dummyContacts.length,
//               itemBuilder: (context, index) {
//                 final contact = dummyContacts[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.blue[100],
//                     child: Icon(Icons.person, color: Colors.blue),
//                   ),
//                   title: Text(contact["name"]!),
//                   onTap: () {
//                     Navigator.pop(context); // close bottom sheet
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) {
//                           return ChatScreen(peerId: peerId, peerName: peerName)
//                         },
//                       ),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         behavior: SnackBarBehavior.floating,
//                         shape: StadiumBorder(),
//                         duration: Duration(seconds: 1),
//                         content: Text("Open chat with ${contact["name"]}"),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
