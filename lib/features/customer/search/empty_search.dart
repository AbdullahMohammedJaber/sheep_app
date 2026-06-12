import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

class EmptySearchScreen extends StatelessWidget {
  const EmptySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppAssets.searchNormal,
          color: AppColors.primary,
          height: 50,
        ),
        SizedBox(height: hi * 0.02),
        CustomText(
          text: "لا توجد نتائج حاليًا",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
        SizedBox(height: hi * 0.02),
        SizedBox(
          width: wi * 0.8,
          child: Center(
            child: CustomText(
              text:
                  "لم نتمكن من العثور على نتائج مطابقة لبحثك أو للفلاتر المحددة. يمكنك تعديل البحث أو توسيع نطاق الفلترة للعثور على المزيد من النتائج.",
              fontSize: 14,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
