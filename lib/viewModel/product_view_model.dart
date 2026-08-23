import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ProductViewModel {
  Future<void> addNewProduct({required Map<String, dynamic> dataMap}) async {
    await FirebaseFirestore.instance.collection("products").add(dataMap);
  }

  Future<void> updateProduct({
    required String docId,
    required Map<String, dynamic> dataMap,
  }) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(docId)
        .update(dataMap);
  }

  Future<void> deleteProduct({required String docId}) async {
    await FirebaseFirestore.instance.collection("products").doc(docId).delete();
  }

  Stream<QuerySnapshot> fetchProducts(String categoryName) {
    return FirebaseFirestore.instance
        .collection("products")
        .where("category", isEqualTo: categoryName.toLowerCase())
        .snapshots();
  }

  Future<void> reduceProductQuantity({
    required String productId,
    required int quantity,
  }) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-quantity)});
  }
}
