import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String productID;
  int quantity;

  CartModel({required this.productID, required this.quantity});

  factory CartModel.fromJson(Map<String, dynamic> jsonData) {
    return CartModel(
      productID: jsonData["product_id"] ?? "",
      quantity: jsonData["quantity"] ?? 0,
    );
  }

  static List<CartModel> fromJsonList(List<QueryDocumentSnapshot> cartList) {
    return cartList
        .map(
          (cartItem) =>
              CartModel.fromJson(cartItem.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
