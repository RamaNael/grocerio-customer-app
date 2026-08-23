// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';

// class AuthViewModel {
//   createUserAccountWithEmailAndPassword(
//     String name,
//     String email,
//     String password,
//   ) async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await storeUserData(name, email);

//       return "SignUp Successfully";
//     } on FirebaseAuthException catch (exp) {
//       return exp.message.toString();
//     }
//   }

//   storeUserData(String name, String email) async {
//     try {
//       Map<String, dynamic> userData = { "name": name,
//   "email": email};

//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .set(userData);
//     } catch (exp) {
//       print("failed to save user data:$exp");
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_ecommerce_app/Providers/user_providers.dart';

class AuthViewModel {
  Future<String> createUserAccountWithEmailAndPassword(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user!;

      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "name": name,
        "email": email,
        "uid": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });
      Provider.of<UserProvider>(context, listen: false).getUserData();

      return "SignUp Successfully";
    } on FirebaseAuthException catch (e) {
      return "Auth Error: ${e.message}";
    } on FirebaseException catch (e) {
      return "Firestore Error: ${e.message}";
    } catch (e) {
      return "Unknown Error: $e";
    }
  }

  Future<String> loginWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Provider.of<UserProvider>(context, listen: false).getUserData();

      return 'Login Successfully';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
