import 'package:chat_box/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Get current user profile pic
  Future<UserModel?> getProfilePic() async {
    try {
      final uid = _auth.currentUser!.uid;

      if (uid == null) {
        return null;
      }

      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///Update profile pic
  Future<void> updateProfilePic(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }
}
