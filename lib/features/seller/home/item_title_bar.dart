
import 'package:flutter/material.dart';
 
import 'package:sheep/util/constants/app_colors.dart' show AppColors;
import 'package:sheep/util/widgets/custom_text.dart';

class ItemTitleBarSeller extends StatelessWidget {
  const ItemTitleBarSeller({super.key});

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
                // Container(
                //   height: 40, 
                //   width: 40, 
                //   color: Colors.transparent,
                //   child: Center(
                //     child: SvgPicture.asset(AppAssets.searchNormal),
                //   ),
                // )
              ],
            ),
          );
  }
}