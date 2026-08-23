import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String idCategory;
  String nameCategory;
  String imageCategory;
  int priorityCategory;

  CategoryModel({
    required this.idCategory,
    required this.nameCategory,
    required this.imageCategory,
    required this.priorityCategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> jsonData, String key) {
    return CategoryModel(
      nameCategory: jsonData["name"] ?? "",
      imageCategory: jsonData["image"] ?? "",
      priorityCategory: jsonData["priority"] ?? 0,
      idCategory: key ?? "",
    );
  }

  static List<CategoryModel> fromJsonList(
    List<QueryDocumentSnapshot> categoriesList,
  ) {
    return categoriesList
        .map(
          (category) => CategoryModel.fromJson(
            category.data() as Map<String, dynamic>,
            category.id,
          ),
        )
        .toList();
  }
}
