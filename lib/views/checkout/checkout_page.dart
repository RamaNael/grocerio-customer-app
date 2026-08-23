import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:provider/provider.dart";
import "package:snap_ecommerce_app/Providers/cart_provider.dart";
import "package:snap_ecommerce_app/Providers/user_providers.dart";
import "package:snap_ecommerce_app/core/theme/app_theme.dart";
import "package:snap_ecommerce_app/models/product_model.dart";
import "package:snap_ecommerce_app/viewModel/cart_viewModel.dart";
import "package:snap_ecommerce_app/viewModel/checkout_veiw_model.dart";
import "package:snap_ecommerce_app/viewModel/order_veiw_model.dart";
import "package:snap_ecommerce_app/viewModel/product_view_model.dart";
import "package:snap_ecommerce_app/views/checkout/payment.dart";

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController couponTextEditingController = TextEditingController();
  int discountValue = 0;
  String discountString = "";
  bool paymentSuccess = false;
  Map<String, dynamic> orderDataMap = {};

  CheckoutViewModel checkoutViewModel = CheckoutViewModel();
  OrderViewModel orderViewModel = OrderViewModel();
  ProductViewModel productViewModel = ProductViewModel();
  CartViewModel cartViewModel = CartViewModel();

  void calculateDiscount(int discountPercentage, int totalCost) {
    discountValue = (discountPercentage * totalCost) ~/ 100;
    setState(() {});
  }

  Future<void> initializeStripePaymentSheet(int paymentAmount) async {
    try {
      final userData = Provider.of<UserProvider>(context, listen: false);

      final data = await createPaymentIntent(
        name: userData.nameOfUser,
        address: userData.addressOfUser,
        amount: (paymentAmount * 100).toString(),
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Grocerio',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment setup failed: $error')));

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(66, 140, 136, 1),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 22),
            SizedBox(width: 8),
            Text("Checkout", style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
            builder: (context, cartData, child) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION - Delivery Details
                    Row(
                      children: const [
                        Icon(Icons.local_shipping_outlined, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "Delivery Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.nameOfUser,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(userData.emailOfUser),
                                Text(userData.addressOfUser),
                                Text(userData.phoneNumberOfUser),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/edit_profile");
                            },
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    // SECTION - Coupons/Discount
                    Row(
                      children: const [
                        Icon(Icons.discount_outlined, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "Have a coupon?",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: couponTextEditingController,
                            decoration: InputDecoration(
                              labelText: "Coupon Code",
                              hintText: "Enter code for discount",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            QuerySnapshot querySnapshot =
                                await checkoutViewModel
                                    .checkDiscountCodeValidity(
                                      discountCode: couponTextEditingController
                                          .text
                                          .toUpperCase(),
                                    );

                            if (querySnapshot.docs.isNotEmpty) {
                              QueryDocumentSnapshot doc =
                                  querySnapshot.docs.first;
                              int percent = doc.get('discount');
                              discountString =
                                  "Discount applied: $percent% off your total.";
                              calculateDiscount(percent, cartData.totalCost);
                            } else {
                              discountString = "Invalid or expired coupon.";
                            }
                            setState(() {});
                          },
                          child: Text("Apply"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (discountString.isNotEmpty) Text(discountString),
                    const SizedBox(height: 40),

                    const Divider(),

                    // SECTION - Order Summary
                    Row(
                      children: const [
                        Icon(Icons.receipt_long_outlined, size: 20),
                        SizedBox(width: 6),
                        Text("Order Summary"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Items: ${cartData.totalQuantity}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Subtotal: 💲${cartData.totalCost}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Extra Discount: - 💲$discountValue",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(),
                    Text(
                      "Total Payable: 💲${cartData.totalCost - discountValue}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          child: ElevatedButton.icon(
            onPressed: () async {
              final userData = Provider.of<UserProvider>(
                context,
                listen: false,
              );

              if (userData.addressOfUser.isEmpty ||
                  userData.phoneNumberOfUser.isEmpty ||
                  userData.nameOfUser.isEmpty ||
                  userData.emailOfUser.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please complete your delivery details."),
                  ),
                );

                return;
              }

              try {
                final totalAmount =
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).totalCost -
                    discountValue;

                await initializeStripePaymentSheet(totalAmount);

                await Stripe.instance.presentPaymentSheet();
                final cartData = Provider.of<CartProvider>(
                  context,
                  listen: false,
                );
                User? currentUser = FirebaseAuth.instance.currentUser;

                List productsList = [];

                for (int i = 0; i < cartData.productsList.length; i++) {
                  productsList.add({
                    "id": cartData.productsList[i].idProduct,
                    "name": cartData.productsList[i].nameProduct,
                    "image": cartData.productsList[i].imageProduct,
                    "single_price": cartData.productsList[i].new_price_Product,
                    "total_price":
                        cartData.productsList[i].new_price_Product *
                        cartData.cartItemsList[i].quantity,
                    "quantity": cartData.cartItemsList[i].quantity,
                  });
                }

                Map<String, dynamic> orderData = {
                  "user_id": currentUser!.uid,
                  "created_at": DateTime.now().millisecondsSinceEpoch,
                  "name": userData.nameOfUser,
                  "email": userData.emailOfUser,
                  "address": userData.addressOfUser,
                  "phone": userData.phoneNumberOfUser,
                  "discount": discountValue,
                  "total": cartData.totalCost - discountValue,
                  "productsList": productsList,
                  "status": "PAID",
                };

                orderDataMap = orderData;

                await orderViewModel.saveNewOrderInfo(data: orderData);

                for (int i = 0; i < cartData.productsList.length; i++) {
                  productViewModel.reduceProductQuantity(
                    productId: cartData.productsList[i].idProduct,
                    quantity: cartData.cartItemsList[i].quantity,
                  );
                }

                await cartViewModel.clearCart();

                paymentSuccess = true;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Online Payment Successful, Order Placed Successfully",
                    ),
                  ),
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment Successful")),
                );
              } catch (error) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Online Payment Failed: $error")),
                );
              }
            },
            icon: const Icon(Icons.lock_clock_outlined),
            label: const Text("Proceed to Payment"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(66, 140, 136, 1),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
