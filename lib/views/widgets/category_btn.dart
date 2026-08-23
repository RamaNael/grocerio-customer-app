import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';

class CategoryBtn extends StatelessWidget {
  final String imageBase64;
  final String name;
  const CategoryBtn({super.key, required this.imageBase64, required this.name});

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(imageBase64);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/show_specific_products',
          arguments: {'name': name},
        );
      },
      child: Container(
        width: 116,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 62,
              width: 62,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.memory(imageBytes, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
