import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/models/coupon_model.dart';
import 'package:snap_ecommerce_app/viewModel/coupon_view_model.dart';

class CouponContainer extends StatefulWidget {
  const CouponContainer({super.key});

  @override
  State<CouponContainer> createState() => _CouponContainerState();
}

class _CouponContainerState extends State<CouponContainer> {
  CouponViewModel couponViewModel = CouponViewModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: couponViewModel.fetchCoupons(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.hasData) {
          final couponsList = CouponModel.fromJsonList(dataSnapshot.data!.docs);
          if (couponsList.isEmpty) return const SizedBox();

          final coupon = couponsList.first;
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pushNamed(context, '/coupons'),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentSoft, Color(0xFFFFFAF5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD7B8)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.local_offer_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today’s deal',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          coupon.codeCoupon,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          coupon.descCoupon,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: AppColors.accent),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
