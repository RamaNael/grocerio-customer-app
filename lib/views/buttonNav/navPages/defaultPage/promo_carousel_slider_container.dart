import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/models/promo_banner_model.dart';
import 'package:snap_ecommerce_app/viewModel/promo_banner_view_model.dart';

class PromoCarouselSliderContainer extends StatefulWidget {
  const PromoCarouselSliderContainer({super.key});

  @override
  State<PromoCarouselSliderContainer> createState() =>
      _PromoCarouselSliderContainerState();
}

class _PromoCarouselSliderContainerState
    extends State<PromoCarouselSliderContainer> {
  PromoBannerViewModel promoBannerViewModel = PromoBannerViewModel();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: promoBannerViewModel.fetchPromoBanner(true),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.hasData) {
          List<PromoBannerModel> promosList = PromoBannerModel.fromJsonList(
            dataSnapshot.data!.docs,
          );

          if (promosList.isEmpty) {
            return Container();
          } else {
            return CarouselSlider(
              items: promosList.map((promo) {
                final imageBytes = base64Decode(promo.imagePromoBanner);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/show_specific_products",
                      arguments: {"name": promo.categoryPromoBanner},
                    );
                  },
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                aspectRatio: 16 / 8,
                viewportFraction: 1,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }
}
