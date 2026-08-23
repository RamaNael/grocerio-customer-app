import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';

class SegmentTitle extends StatelessWidget {
  final String titleSegment;
  const SegmentTitle({super.key, required this.titleSegment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          titleSegment,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
