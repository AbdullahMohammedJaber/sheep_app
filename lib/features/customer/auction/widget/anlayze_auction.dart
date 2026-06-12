// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget anlayesAuctionSection({
  required dynamic statrtPrice,
  required dynamic currentPrice,
  required bool isSeller,
  required dynamic countBids,
}) {
  return SizedBox(
    height: 100,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (isSeller) ...[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(text: "عدد المزايدات"),
                  const SizedBox(height: 8),
                  CustomText(
                    text: "$countBids",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffE9F3FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(text: "سعر البداية"),
                const SizedBox(height: 8),
                CustomText(
                  text: "$statrtPrice ر.س",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffEAF2EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(text: "السعر الحالي"),
                const SizedBox(height: 8),
                CustomText(
                  text: "$currentPrice ر.س",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
