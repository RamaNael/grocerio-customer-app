import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:snap_ecommerce_app/models/cart_model.dart";
import "package:snap_ecommerce_app/models/product_model.dart";
import "package:snap_ecommerce_app/viewModel/cart_viewModel.dart";

class CartProvider extends ChangeNotifier {
  CartViewModel cartViewModel = CartViewModel();
  StreamSubscription<QuerySnapshot>? cartStreamSubscription;
  StreamSubscription<QuerySnapshot>? productStreamSubscription;

  List<CartModel> cartItemsList = [];
  List<String> cartUIDsList = [];
  List<ProductModel> productsList = [];

  bool isProgressing = true;
  int totalCost = 0;
  int totalQuantity = 0;

  CartProvider() {
    getCartItemsData();
  }

  @override
  void dispose() {
    declineProvider();
    super.dispose();
  }

  void declineProvider() {
    cartStreamSubscription?.cancel();
    productStreamSubscription?.cancel();
  }

  void addItemDataToCart(CartModel cartItemData) {
    cartViewModel.saveItemDataToCart(cartItemData: cartItemData);
  }

  void getCartItemsData() {
    isProgressing = true;

    cartStreamSubscription?.cancel();
    cartStreamSubscription = cartViewModel.fetchUserCart().listen((snapshot) {
      List<CartModel> cartItemData = CartModel.fromJsonList(snapshot.docs);

      cartItemsList = cartItemData;

      cartUIDsList = [];
      for (int i = 0; i < cartItemsList.length; i++) {
        cartUIDsList.add(cartItemsList[i].productID);
      }

      if (cartItemsList.isNotEmpty) {
        getCartItemsProducts(cartUIDsList);
      }

      isProgressing = false;
      notifyListeners();
    });
  }

  void getCartItemsProducts(List<String> uIDsList) {
    productStreamSubscription?.cancel();

    productStreamSubscription = cartViewModel
        .fetchCartItemsProducts(uIDsList)
        .listen((snapshot) {
          List<ProductModel> productsData = ProductModel.fromJsonList(
            snapshot.docs,
          );

          productsList = productsData;
          isProgressing = false;

          calculateTotalCost();

          calculateTotalQuantity();

          notifyListeners();
        });
  }

  void calculateTotalCost() {
    totalCost = 0;

    for (final cartItem in cartItemsList) {
      final matchingProduct = productsList.where(
        (product) => product.idProduct == cartItem.productID,
      );

      if (matchingProduct.isNotEmpty) {
        totalCost +=
            cartItem.quantity * matchingProduct.first.new_price_Product;
      }
    }
  }

  void calculateTotalQuantity() {
    totalQuantity = 0;

    for (int i = 0; i < cartItemsList.length; i++) {
      totalQuantity += cartItemsList[i].quantity;
    }

    notifyListeners();
  }

  Future<void> deleteItemFromCart(String productID) async {
    await cartViewModel.removeItemFromCart(docID: productID);
  }

  Future<void> decreaseQuantityCount(String productID) async {
    await cartViewModel.decrementQuantityCount(docID: productID);
    notifyListeners();
  }
}
