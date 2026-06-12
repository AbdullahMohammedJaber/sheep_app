// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool isTablet;
  final Color colotTitle;
  const ProfileMenuItem({
    super.key,
    required this.icon,
    this.iconColor = AppColors.primary,
    required this.title,
    required this.onTap,
    this.isTablet = false,
    this.colotTitle = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(child: SvgPicture.asset(icon)),
            ),
            SizedBox(width: isTablet ? 14 : 12),

            CustomText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colotTitle,
            ),
          ],
        ),
      ),
    );
  }
}
