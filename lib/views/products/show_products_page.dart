import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/models/product_model.dart';
import 'package:snap_ecommerce_app/viewModel/common_veiw_model.dart';
import 'package:snap_ecommerce_app/viewModel/product_view_model.dart';

class ShowProductsPage extends StatefulWidget {
  const ShowProductsPage({super.key});

  @override
  State<ShowProductsPage> createState() => _ShowProductsPageState();
}

class _ShowProductsPageState extends State<ShowProductsPage> {
  final ProductViewModel productViewModel = ProductViewModel();
  final CommonViewModel commonViewModel = CommonViewModel();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(args['name'])),

      body: StreamBuilder(
        stream: productViewModel.fetchProducts(args['name']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final productsList = ProductModel.fromJsonList(snapshot.data!.docs);

          if (productsList.isEmpty) {
            return const _EmptyProducts();
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              crossAxisSpacing: 6,
              mainAxisSpacing: 6,

              // Keep the original card proportion
              childAspectRatio: 0.66,
            ),

            itemCount: productsList.length,

            itemBuilder: (context, index) {
              final product = productsList[index];

              final imageBytes = base64Decode(product.imageProduct);

              final discount = commonViewModel.getDiscountPercentage(
                product.old_price_Product,
                product.new_price_Product,
              );

              // Padding around each card makes the
              // visible card slightly smaller.
              return Padding(
                padding: const EdgeInsets.all(4),

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(color: AppColors.border),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============================
                      // PRODUCT IMAGE
                      // ============================
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,

                              margin: const EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(14),
                              ),

                              padding: const EdgeInsets.all(10),

                              child: Image.memory(
                                imageBytes,

                                // Keep image like before
                                fit: BoxFit.contain,
                              ),
                            ),

                            // ============================
                            // DISCOUNT BADGE
                            // ============================
                            Positioned(
                              top: 14,
                              left: 14,

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors.accent,

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  '-$discount%',

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ============================
                      // PRODUCT INFORMATION
                      // ============================
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
                            Text(
                              product.nameProduct,

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.25,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // ============================
                            // PRICE
                            // ============================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${product.new_price_Product}',

                                  style: const TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(width: 7),

                                Expanded(
                                  child: Text(
                                    '\$${product.old_price_Product}',

                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // ============================
                            // VIEW DETAILS BUTTON
                            // ============================
                            SizedBox(
                              width: double.infinity,
                              height: 36,

                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product_details',
                                    arguments: product,
                                  );
                                },

                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 15,
                                ),

                                label: const Text('View Details'),

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,

                                  foregroundColor: Colors.white,

                                  elevation: 0,

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),

                                  // Overrides your global
                                  // 52px button minimum.
                                  minimumSize: const Size(0, 36),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 58,
            color: AppColors.textSecondary,
          ),

          SizedBox(height: 12),

          Text(
            'No products found',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
