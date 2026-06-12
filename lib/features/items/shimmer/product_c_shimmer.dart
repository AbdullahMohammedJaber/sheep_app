import 'package:flutter/material.dart';
import 'package:sheep/features/items/shimmer/shimmer_root.dart';
 import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/main.dart';
import 'package:shimmer/shimmer.dart';

 
class ProductItemShimmer extends StatelessWidget {
  const ProductItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: wi * 0.7,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// image
            const ShimmerBox(
              height: 200,
              width: double.infinity,
              radius: 12,
            ),

            SizedBox(height: hi * 0.02),

            /// title
            const ShimmerBox(height: 18, width: double.infinity),

            SizedBox(height: hi * 0.01),

            /// price
            const ShimmerBox(height: 18, width: 100),

            SizedBox(height: hi * 0.02),

            /// location
            Row(
              children: [
                const ShimmerBox(height: 16, width: 16),
                SizedBox(width: wi * 0.02),
                const Expanded(
                  child: ShimmerBox(height: 14, width: double.infinity),
                ),
              ],
            ),

            SizedBox(height: hi * 0.02),

            /// button
            const ShimmerBox(height: 45, width: double.infinity, radius: 12),
          ],
        ),
      ),
    );
  }
}