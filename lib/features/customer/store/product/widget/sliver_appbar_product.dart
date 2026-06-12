// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/features/seller/product/widget/show_image_list.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

Widget buildSliverAppBarProduct(
  BuildContext context, {
  required bool isCollapsed,
  required DetailsProductSellerResponse data,
}) {
  return SliverAppBar(
    expandedHeight: hi * 0.3,
    pinned: true,
    stretch: true,
    backgroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,

    title: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isCollapsed ? 1.0 : 0.0,
      child: CustomText(
        text: data.data!.name!,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    ),

    actions: [
      SizedBox(width: 12),
      GestureDetector(
  onTap: () => Navigator.pop(context),
  child: Container(
    height: 44,
    width: 44,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.35),
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: SvgPicture.asset(
        AppAssets.arrowLeft,
        color: Colors.white,
        width: 20,
        height: 20,
      ),
    ),
  ),
),
      const Spacer(),
    ],

    flexibleSpace: FlexibleSpaceBar(
      stretchModes: const [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
      ],
      background: Container(
        color: Colors.grey.shade300,
        width: double.infinity,
        child: ProductImagesSlider(
          images:
              data.data!.images!
                  .map((element) => AppAssets.parseImageUrl(element.imageName!))
                  .toList(),
        ),
      ),
    ),
  );
}

Widget statucTimeAuction() {
  return Container(
    height: 100,
    width: wi,
    margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.timer, color: AppColors.textSecondary),
              SizedBox(height: 10),
              CustomText(
                text: "ينتهي المزاد خلال",
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              CustomText(
                text: "2:45:30",
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.auction,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 10),
              CustomText(
                text: "عدد المزايدات",
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              CustomText(
                text: "15",
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
