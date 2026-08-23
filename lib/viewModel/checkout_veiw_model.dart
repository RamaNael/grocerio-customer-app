import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutViewModel {
  Future<QuerySnapshot> checkDiscountCodeValidity({
    required String discountCode,
  }) {
    return FirebaseFirestore.instance
        .collection("coupons")
        .where("code", isEqualTo: discountCode)
        .get();
  }
}
