// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/core/data/response/product/product_customer_response.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/customer/store/product/product_details.dart';
import 'package:sheep/main.dart';

class ProductItem extends StatelessWidget {
  ProductCustomer productCustomer;
  ProductItem({super.key, required this.productCustomer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToWithFade(context, ProductDetailsScreen(id: productCustomer.id));
      },
      child: Container(
        width: wi * 0.7,
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                AppAssets.parseImageUrl(productCustomer.imageName!),
                fit: BoxFit.cover,
                height: hi * 0.25,
                width: double.infinity,
              ),
            ),
            SizedBox(height: hi * 0.02),

            CustomText(
              text: productCustomer.name!,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: hi * 0.007),
            CustomText(
              text: "${productCustomer.fixedPrice} د.ك",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: hi * 0.007),

            Row(
              children: [
                SvgPicture.asset(AppAssets.location),
                SizedBox(width: wi * 0.02),
                Expanded(
                  child: CustomText(
                    text: productCustomer.address!,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: hi * 0.01),

            Center(
              child: CustomButton(
                onTap: () {
                  ToWithFade(
                    context,
                    ProductDetailsScreen(id: productCustomer.id),
                  );
                },
                title: "تفاصيل الإعلان",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
