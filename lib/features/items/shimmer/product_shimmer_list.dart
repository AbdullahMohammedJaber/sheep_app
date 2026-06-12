import 'package:flutter/material.dart';
import 'package:sheep/features/items/shimmer/product_c_shimmer.dart';

class ProductsShimmerList extends StatelessWidget {
  const ProductsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => const ProductItemShimmer(),
        ),
      ),
    );
  }
}