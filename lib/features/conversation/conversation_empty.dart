// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

class ConversationEmpty extends StatelessWidget {
  const ConversationEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: AppColors.border.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.chat,
              color: AppColors.primary,
              height: 80,
            ),
          ),
        ),
        SizedBox(height: hi * 0.02),
        CustomText(
          text: "لا توجد محادثات حاليًا",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        SizedBox(height: hi * 0.02),
        CustomText(
          text: "تصفح الأسواق وتواصل مع البائعين",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: hi * 0.02),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: wi * 0.2),
        //   child: CustomButton(title: "عرض الأسواق", onTap: () {}),
        // ),
      ],
    );
  }
}
