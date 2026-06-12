import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/main.dart';

class ShopItemShimmer extends StatelessWidget {
  const ShopItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: wi * 0.55,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 200,
                  width: wi * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: hi * 0.02),

            // ================= NAME =================
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),

            SizedBox(height: hi * 0.012),

            // ================= LOCATION =================
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: Colors.grey.shade300,
                ),
                SizedBox(width: wi * 0.02),
                Expanded(
                  child: Container(
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),

            SizedBox(height: hi * 0.015),

            // ================= PRODUCTS =================
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: Colors.grey.shade300,
                ),
                SizedBox(width: 5),
                Container(
                  height: 12,
                  width: 80,
                  color: Colors.grey.shade300,
                ),
              ],
            ),

            SizedBox(height: hi * 0.02),

            // ================= BUTTON =================
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}