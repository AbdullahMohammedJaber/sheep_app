import 'package:flutter/material.dart';
import 'package:sheep/features/items/shimmer/shop_c_shimmer.dart';
 
class ShopsShimmerList extends StatelessWidget {
  const ShopsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return const ShopItemShimmer();
        },
      ),
    );
  }
}