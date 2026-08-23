import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserViewModel {
  Stream<DocumentSnapshot> retrieveUserData() {
    if (FirebaseAuth.instance.currentUser == null) {
      return Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<void> updateUserData({required Map<String, dynamic> userData}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userData);
  }
}
