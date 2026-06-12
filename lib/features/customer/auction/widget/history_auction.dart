import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget historyAuction({
  required List bids,
}) {
  return Row(
    children: [
      const Expanded(
        child: CustomText(
          text: "سجل المزايدات",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xff363D4E),
        ),
      ),
      Row(
        children: [
          SvgPicture.asset(AppAssets.users),
          const SizedBox(width: 5),
          CustomText(
            text: "${bids.length} مشارك",
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    ],
  );
}