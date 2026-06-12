
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/notification/notification_screen.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart' show AppColors;
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class ItemTitleBar extends StatelessWidget {
  const ItemTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "مرحبًا بك 👋",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
                GestureDetector(
                  onTap: () {
                    ToWithFade(context,NotificationsScreen());
                  },
                  child: Container(
                    height: 40, 
                    width: 40, 
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(AppAssets.bell),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}