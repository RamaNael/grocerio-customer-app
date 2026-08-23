import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/defaultPage/bannerContainer/banner_container.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/defaultPage/category_container.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/defaultPage/coupon_container.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/defaultPage/promo_carousel_slider_container.dart';
import 'package:snap_ecommerce_app/views/widgets/segment_title.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 78,
        title: Image.asset(
          'images/icon.png',
          width: 164,
          height: 40,
          fit: BoxFit.contain,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: 'Cart',
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _WelcomeCard(),
            SizedBox(height: 26),
            SegmentTitle(titleSegment: 'Exclusive Offers'),
            SizedBox(height: 12),
            PromoCarouselSliderContainer(),
            SizedBox(height: 26),
            SegmentTitle(titleSegment: 'Special Offers'),
            SizedBox(height: 12),
            CouponContainer(),
            SizedBox(height: 26),
            SegmentTitle(titleSegment: 'Shop by Category'),
            SizedBox(height: 12),
            CategoryContainer(),
            SizedBox(height: 26),
            SegmentTitle(titleSegment: 'Top Picks for You'),
            SizedBox(height: 12),
            BannerContainer(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fresh groceries,\nmade simple.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Browse today’s offers and fill your cart in minutes.',
                      style: TextStyle(
                        color: Color(0xFFE4FFFD),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12),

              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(
                  Icons.local_grocery_store_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
