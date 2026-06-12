import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/seller/product/widget/section_title.dart';

 
class ProductCategorySection extends StatelessWidget {
  final String selectedCategory;
  final VoidCallback onTap;

  const ProductCategorySection({
    super.key,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE7E7E7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('التصنيف'),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
               
                CustomText(
                 text:  selectedCategory,
                  color: AppColors.black,
                ),
                Spacer(), 
                SvgPicture.asset(AppAssets.dropDown),
              ],
            ),
          ),
        ),
      ],
    );
  }
}