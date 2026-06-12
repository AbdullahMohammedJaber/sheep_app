// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
 import 'package:sheep/core/data/response/product/product_seller_response.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/seller/product/details_product_seller.dart';
import 'package:sheep/main.dart';

class ProductItemSellerState extends StatelessWidget {
  final ProductSeller productSeller;
  const ProductItemSellerState({super.key , required this.productSeller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToWithFade(context, DetailsProductSeller(id: productSeller.id,));
      },
      child: Container(
        width: wi * 0.7,

        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    AppAssets.parseImageUrl(productSeller.imageName!),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                // Row(
                //   children: [
                //     Container(
                //       height: 30,

                //       decoration: BoxDecoration(
                //         color: AppColors.black.withOpacity(0.8),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             SvgPicture.asset(AppAssets.rate),
                //             SizedBox(width: 5),
                //             CustomText(
                //               text: "4.5",
                //               fontSize: 14,
                //               fontWeight: FontWeight.w700,
                //               color: AppColors.white,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Container(
                //       height: 30,
                //       margin: EdgeInsets.only(right: 5),
                //       decoration: BoxDecoration(
                //         color: AppColors.primary,
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Center(
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 5),
                //           child: CustomText(
                //             text: "قيد المراجعة",
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //             color: AppColors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            SizedBox(height: hi * 0.02),

            CustomText(
              text: productSeller.name!,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: hi * 0.01),
            CustomText(
              text: "${productSeller.fixedPrice} د.ك",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              overflow: TextOverflow.ellipsis,
            ),
            // SizedBox(height: hi * 0.015),
            // Row(
            //   children: [
            //     SvgPicture.asset(AppAssets.eye),
            //     SizedBox(width: wi * 0.02),
            //     Expanded(
            //       child: CustomText(
            //         text: "24 مشاهدة",
            //         fontSize: 15,
            //         fontWeight: FontWeight.w400,
            //         color: Color(0xff666666),
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
