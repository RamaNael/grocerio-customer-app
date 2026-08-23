import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class BannerUi extends StatelessWidget {
  final Uint8List image;
  final String category;
  const BannerUi({super.key, required this.image, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/show_specific_products",
          arguments: {"name": category},
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 149,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(19)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Image.memory(image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
