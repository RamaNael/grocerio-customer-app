import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PromoBannerViewModel {
  Future<void> createPromoBanner({
    required Map<String, dynamic> dataMap,
    required bool promoPage,
  }) async {
    await FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .add(dataMap);
  }

  Future<void> updatePromoBanner({
    required Map<String, dynamic> dataMap,
    required bool promoPage,
    required String docID,
  }) async {
    await FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .doc(docID)
        .update(dataMap);
  }

  Future<void> deletePromoBanner({
    required bool promoPage,
    required String docID,
  }) async {
    await FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .doc(docID)
        .delete();
  }

  Stream<QuerySnapshot> fetchPromoBanner(bool promoPage) {
    return FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .snapshots();
  }
}
