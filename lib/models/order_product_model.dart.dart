class OrderProductModel {
  String idOrderProduct;
  String name;
  String image;
  int quantity;
  int single_price;
  int total_price;

  OrderProductModel({
    required this.idOrderProduct,
    required this.name,
    required this.image,
    required this.quantity,
    required this.single_price,
    required this.total_price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> jsonData) {
    return OrderProductModel(
      idOrderProduct: jsonData["id"] ?? "",
      name: jsonData["name"] ?? "",
      image: jsonData["image"] ?? "",
      quantity: jsonData["quantity"] ?? 0,
      single_price: jsonData["single_price"] ?? 0,
      total_price: jsonData["total_price"] ?? 0,
    );
  }
}
