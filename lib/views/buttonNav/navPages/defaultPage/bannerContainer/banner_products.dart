import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:snap_ecommerce_app/models/product_model.dart";
import "package:snap_ecommerce_app/viewModel/common_veiw_model.dart";
import "package:snap_ecommerce_app/viewModel/product_view_model.dart";

class BannerProducts extends StatefulWidget {
  final String categoryName;

  const BannerProducts({super.key, required this.categoryName});

  @override
  State<BannerProducts> createState() => _BannerProductsState();
}

class _BannerProductsState extends State<BannerProducts> {
  final ProductViewModel productViewModel = ProductViewModel();
  final CommonViewModel commonViewModel = CommonViewModel();

  final List<Color> _colorPalette = [
    Colors.green.shade50,
    Colors.pink.shade50,
    Colors.indigo.shade50,
    Colors.purple.shade50,
    Colors.teal.shade50,
    Colors.deepPurple.shade50,
    Colors.cyan.shade50,
    Colors.blue.shade50,
    Colors.orange.shade50,
    Colors.lime.shade50,
  ];

  Color getRandomColorForCategory(String category) {
    final hash = category.toLowerCase().runes.fold(
      0,
      (prev, char) => prev + char,
    );

    return _colorPalette[hash % _colorPalette.length];
  }

  Widget specialQuote({required int price, required int discountPercentage}) {
    final random = Random().nextInt(2);

    final List<String> quotes = [
      "Grab it for just 💲$price",
      "Enjoy discounts of up to $discountPercentage%",
    ];

    return Text(
      quotes[random],
      style: const TextStyle(color: Colors.green, fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void openAllProducts() {
    Navigator.pushNamed(
      context,
      "/show_specific_products",
      arguments: {"name": widget.categoryName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: productViewModel.fetchProducts(widget.categoryName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<ProductModel> products = ProductModel.fromJsonList(
          snapshot.data!.docs,
        );

        if (products.isEmpty) {
          return const Center(child: Text("No Products Found"));
        }

        // Show only 6 products maximum
        final int productsToShow = min(products.length, 6);

        // Show "See all" only when more than 6 products exist
        final bool hasMoreProducts = products.length > 6;

        return Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: getRandomColorForCategory(widget.categoryName),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // CATEGORY HEADER
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    if (hasMoreProducts)
                      TextButton.icon(
                        onPressed: openAllProducts,
                        label: const Text(
                          "See all",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        icon: const Icon(Icons.chevron_right_rounded),
                        iconAlignment: IconAlignment.end,
                      ),
                  ],
                ),
              ),

              // =========================
              // PRODUCT GRID
              // =========================
              SizedBox(
                height: 400,
                child: GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.horizontal,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(8),

                  children: [
                    // =========================
                    // FIRST 6 PRODUCTS
                    // =========================
                    ...List.generate(productsToShow, (i) {
                      final product = products[i];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/product_details",
                            arguments: product,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Builder(
                                    builder: (context) {
                                      final imgBytes = base64Decode(
                                        product.imageProduct,
                                      );

                                      return Image.memory(
                                        imgBytes,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                product.nameProduct,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              specialQuote(
                                price: product.new_price_Product,
                                discountPercentage: int.parse(
                                  commonViewModel.getDiscountPercentage(
                                    product.old_price_Product,
                                    product.new_price_Product,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // =========================
                    // SEE ALL / FORWARD CARD
                    // =========================
                    if (hasMoreProducts)
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: openAllProducts,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Color(0xFFE8F5E9),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 28,
                                  color: Colors.green,
                                ),
                              ),

                              SizedBox(height: 12),

                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                "More products",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
