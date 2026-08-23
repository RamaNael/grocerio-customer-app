import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String idCoupon;
  String codeCoupon;
  int discountCoupon;
  String descCoupon;

  CouponModel({
    required this.idCoupon,
    required this.codeCoupon,
    required this.discountCoupon,
    required this.descCoupon,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json, String docID) {
    return CouponModel(
      idCoupon: docID,
      codeCoupon: json["code"] ?? "",
      discountCoupon: json["discount"] ?? 0,
      descCoupon: json["desc"] ?? "",
    );
  }

  static List<CouponModel> fromJsonList(
    List<QueryDocumentSnapshot> couponsList,
  ) {
    return couponsList
        .map(
          (coupon) => CouponModel.fromJson(
            coupon.data() as Map<String, dynamic>,
            coupon.id,
          ),
        )
        .toList();
  }
}
