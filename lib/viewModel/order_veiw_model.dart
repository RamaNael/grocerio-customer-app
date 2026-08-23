import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderViewModel {
  Future<void> saveNewOrderInfo({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("orders").add(data);
  }

  Stream<QuerySnapshot> fetchOrders() {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus({
    required String docId,
    required Map<String, dynamic> orderData,
  }) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(docId)
        .update(orderData);
  }
}
