// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
 import 'package:sheep/util/widgets/custom_text.dart';

class ProductSearchItem extends StatelessWidget {
  final String title;
  final String price;
  final String currency;
  final String location;
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDetailsTap;

  const ProductSearchItem({
    super.key,
    required this.title,
    required this.price,
    this.currency = 'د.ك',
    required this.location,
    required this.imageUrl,
    this.onTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;
    final imageSize = isLargeScreen ? 180.0 : (isTablet ? 150.0 : 130.0);
    final horizontalPadding = isLargeScreen ? 20.0 : (isTablet ? 16.0 : 12.0);
    final verticalPadding = isLargeScreen ? 16.0 : (isTablet ? 14.0 : 12.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: EdgeInsets.all(verticalPadding),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  AppAssets.parseImageUrl(imageUrl),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: imageSize * 0.4,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: horizontalPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: title,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),

                    SizedBox(height: isTablet ? 10 : 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: price,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: currency,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 12 : 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(child: SvgPicture.asset(AppAssets.location)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: CustomText(
                            text: location,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 14 : 12),

                    GestureDetector(
                      onTap: (){
                        if (onDetailsTap != null) {
                          onDetailsTap!();
                        } else {
                           
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'تفاصيل الإعلان',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
