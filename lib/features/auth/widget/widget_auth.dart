import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

Widget arrowLift(BuildContext context, String title  , {bool canBack = true}) {
  return Row(
    children: [
      if(canBack)
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          height: 50,
          width: 50,
          child: Center(child: SvgPicture.asset(AppAssets.arrowLeft)),
        ),
      ),
      
      SizedBox(width:!canBack? wi * 0.05 : wi * 0.002),

      CustomText(
        text: title,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
    ],
  );
}
