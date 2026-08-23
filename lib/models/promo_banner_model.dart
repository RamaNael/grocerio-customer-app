import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannerModel {
  final String titlePromoBanner;
  final String imagePromoBanner;
  final String categoryPromoBanner;
  final String idPromoBanner;

  PromoBannerModel({
    required this.titlePromoBanner,
    required this.imagePromoBanner,
    required this.categoryPromoBanner,
    required this.idPromoBanner,
  });

  // fromJson is used to convert ONE Firestore document data
  // from Map<String, dynamic> into ONE PromoBannerModel object.
  //
  // jsonData contains the document fields, for example:
  // title, image, category
  //
  // docID is passed separately because the Firestore document ID
  // is not stored inside jsonData.

  factory PromoBannerModel.fromJson(
    Map<String, dynamic> jsonData,
    String docID,
  ) {
    return PromoBannerModel(
      titlePromoBanner: jsonData["title"] ?? "",
      imagePromoBanner: jsonData["image"] ?? "",
      categoryPromoBanner: jsonData["category"] ?? "",
      idPromoBanner: docID,
    );
  }

  // fromJsonList is used to convert MANY Firestore documents
  // into a List of PromoBannerModel objects.
  //
  // It saves us from writing a for-loop every time we fetch
  // many promo banners from Firestore.
  //
  // Internally, it loops through each Firestore document,
  // calls fromJson() for each one,
  // then returns the final List<PromoBannerModel>.
  static List<PromoBannerModel> fromJsonList(
    List<QueryDocumentSnapshot> promosBannerList,
  ) {
    return promosBannerList
        .map(
          (promoBanner) => PromoBannerModel.fromJson(
            promoBanner.data() as Map<String, dynamic>,
            promoBanner.id,
          ),
        )
        .toList();
  }
}
