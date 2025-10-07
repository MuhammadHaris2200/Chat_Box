import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  ///Firebase auth se hum sign in, sign out, current user
  ///ya firebase k different methods ko access kr kste ha
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///Firestore se hum document vagera ko read/write kr skte ha
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Ye google account picker show krta ha or token deta ha
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ///Kisi bhi jagah se hum current user ko get kr skte ha
  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      ///Google account picker open hota ha qk hum ne (googleUser) ko
      ///is equal kiya ha (_googleSignIn.signIn()) k, or phir user account pick krega
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      ///Agr user ne cancel krdiya tw picker hat jaega or null return
      ///hota ha error se bachne k liye ye null return krvaya ha
      if (googleUser == null) return null;

      ///(googleUser) ye vo user ha jo google k through sign in hova ha
      ///(.authentication) call kr k hum us user k authentication token lete ha firebase se
      ///or phir hum ne us user ko equal krdiya (googleAuth) k jiska mtlb k google se
      ///sign in hone vale user ka authentication data is variable ma rkh do
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      ///ye jo tokens ha is ki help se user firebase ma sign in hota ha
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      ///phir firebase ko bola k ye google se sign in hone
      ///vale user k google credentials ha isko sign in krdo
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      ///phir us k bd sirf us user k credentials le rhe ha jo current user ho
      final user = userCredential.user!;

      ///phir kaha k agr user k account already exist nhi ha tw google se
      ///sign in krne k sath sath us user ki info bhi firestore ma store krdo
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (!doc.exists) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": user.displayName ?? '',
          "email": user.email ?? '',
          "about": "Hey there I am using ChatBox",
          "phone": "",
          "profilePic": "",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      ///or phir sb hone k bd user ko return krdo
      return user;

      ///or kisi bhi error ki surat ma excpetion throw krdo
    } on FirebaseAuthException catch (e) {
      throw Exception("Google sign in failed: $e");
    } catch (e) {
      throw Exception("Something went wrrong: $e");
    }
  }
}
