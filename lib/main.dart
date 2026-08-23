import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:snap_ecommerce_app/Providers/cart_provider.dart';
import 'package:snap_ecommerce_app/Providers/user_providers.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/views/auth/create_account_page.dart';
import 'package:snap_ecommerce_app/views/auth/login_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/home_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/cart_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/order/order_details.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/order/orders_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/profile/edit_profile_page.dart';
import 'package:snap_ecommerce_app/views/checkout/checkout_page.dart';
import 'package:snap_ecommerce_app/views/coupons/coupons_page.dart';
import 'package:snap_ecommerce_app/views/products/products_details_page.dart';
import 'package:snap_ecommerce_app/views/products/show_products_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  await Stripe.instance.applySettings();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Grocerio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routes: {
          // "/": (context) => CheckUserStatus(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => CreateAccountPage(),
          "/home": (context) => HomePage(),
          "/show_specific_products": (context) => ShowProductsPage(),
          "/product_details": (context) => ProductsDetailsPage(),
          "/coupons": (context) => CouponsPage(),
          "/cart": (context) => CartPage(),
          "/checkout": (context) => CheckoutPage(),
          "/edit_profile": (context) => EditProfilePage(),
          "/orders": (context) => OrdersPage(),
          "/order_details": (context) => OrderDetailsPage(),
        },
        home: LoginPage(),
        // CheckUserStatus(),
      ),
    );
  }
}
