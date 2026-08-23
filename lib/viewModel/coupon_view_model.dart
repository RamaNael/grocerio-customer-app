import 'package:cloud_firestore/cloud_firestore.dart';

class CouponViewModel {
  addNewCoupon({required Map<String, dynamic> couponDataMap}) async {
    await FirebaseFirestore.instance.collection("coupons").add(couponDataMap);
  }

  updateCoupon({
    required String docId,
    required Map<String, dynamic> couponDataMap,
  }) async {
    await FirebaseFirestore.instance
        .collection("coupons")
        .doc(docId)
        .update(couponDataMap);
  }

  deleteCoupon({required String docId}) async {
    await FirebaseFirestore.instance.collection("coupons").doc(docId).delete();
  }

  Stream<QuerySnapshot> fetchCoupons() {
    return FirebaseFirestore.instance.collection("coupons").snapshots();
  }
}
