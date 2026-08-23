import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/models/category_model.dart';
import 'package:snap_ecommerce_app/models/promo_banner_model.dart';
import 'package:snap_ecommerce_app/viewModel/categories_view_model.dart';
import 'package:snap_ecommerce_app/viewModel/promo_banner_view_model.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/defaultPage/bannerContainer/banner_products.dart';
import 'package:snap_ecommerce_app/views/widgets/banner_ui.dart';

class BannerContainer extends StatefulWidget {
  const BannerContainer({super.key});

  @override
  State<BannerContainer> createState() => _BannerContainerState();
}

class _BannerContainerState extends State<BannerContainer> {
  PromoBannerViewModel promoBannerViewModel = PromoBannerViewModel();
  CategoryViewModel categoryViewModel = CategoryViewModel();
  int minLength = 0;
  int calculateMinimumLength(int totalCategories, int totalBanners) {
    return minLength = totalCategories > totalBanners
        ? totalBanners
        : totalCategories;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoryViewModel.fetchCategories(),
      builder: (context, categorySnapshot) {
        if (categorySnapshot.hasData) {
          List<CategoryModel> categories = CategoryModel.fromJsonList(
            categorySnapshot.data!.docs,
          );

          if (categories.isEmpty) {
            return const SizedBox();
          } else {
            return StreamBuilder(
              stream: promoBannerViewModel.fetchPromoBanner(false),
              builder: (context, bannerSnapshot) {
                if (bannerSnapshot.hasData) {
                  final int length = calculateMinimumLength(
                    categorySnapshot.data!.docs.length,
                    bannerSnapshot.data!.docs.length,
                  );

                  return Column(
                    children: [
                      for (int i = 0; i < length; i++)
                        Builder(
                          builder: (context) {
                            final categoryName =
                                categorySnapshot.data!.docs[i]["name"];

                            final matchingBanners = bannerSnapshot.data!.docs
                                .where(
                                  (banner) =>
                                      banner["category"] == categoryName,
                                )
                                .toList();

                            return Column(
                              children: [
                                BannerProducts(categoryName: categoryName),

                                if (matchingBanners.isNotEmpty)
                                  BannerUi(
                                    image: base64Decode(
                                      matchingBanners.first["image"],
                                    ),
                                    category: matchingBanners.first["category"],
                                  ),
                              ],
                            );
                          },
                        ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
