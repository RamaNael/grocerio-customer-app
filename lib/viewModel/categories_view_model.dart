import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryViewModel {
  addNewCategory({required Map<String, dynamic> dataMap}) async {
    await FirebaseFirestore.instance.collection("categories").add(dataMap);
  }

  updateCategory({
    required String docId,
    required Map<String, dynamic> dataMap,
  }) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(docId)
        .update(dataMap);
  }

  deleteCategory({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(docId)
        .delete();
  }

  Stream<QuerySnapshot> fetchCategories() {
    return FirebaseFirestore.instance
        .collection("categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }
}
