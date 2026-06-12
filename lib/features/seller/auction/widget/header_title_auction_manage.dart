// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/seller/auction/auction_form_screen.dart';

Widget headerTitleAuctionManage(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: "إدارة المزادات",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xff363D4E),
        ),
        GestureDetector(
          onTap: () {
            ToWithFade(context, AuctionFormScreen());
          },
          child: Container(
            height: 40,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset(AppAssets.add, color: AppColors.primary),
                  SizedBox(width: 5),
                  CustomText(text: "إضافة مزاد", color: AppColors.primary),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
