// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/core/data/response/shop/shop_response.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/customer/store/shop/details_shop.dart';
import 'package:sheep/main.dart';

class ShopItem extends StatelessWidget {
  final ShopItemRes shop;
  const ShopItem({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToWithFade(context, DetailsShopScreen(
          userId: shop.userId.toString()
        ));
      },
      child: Container(
        width: wi * 0.55,
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

              child: CachedNetworkImage(
                imageUrl: AppAssets.parseImageStoreUrl(shop.image ?? ""),
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) => Image.network(
                      "https://picsum.photos/200/200?random=1",
                      fit: BoxFit.cover,
                      height: hi * 0.25,
                      width: double.infinity,
                    ),
                fit: BoxFit.cover,
                height: hi * 0.25,
                width: double.infinity,
              ),
            ),
            SizedBox(height: hi * 0.01),

            CustomText(
              text: shop.storeName ?? "اسم المتجر",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: hi * 0.01),

            Row(
              children: [
                SvgPicture.asset(AppAssets.location),
                SizedBox(width: wi * 0.02),
                Expanded(
                  child: CustomText(
                    text: shop.storeAddress ?? 'جدة، السعودية',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: hi * 0.015),
            // Row(
            //   children: [
            //     SvgPicture.asset(AppAssets.product),
            //     SizedBox(width: 5),
            //     CustomText(
            //       text: "${shop.??"اسم المتجر"} منتج",
            //       fontSize: 10,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ],
            // ),
            // SizedBox(height: hi * 0.01),
            Center(
              child: CustomButton(
                onTap: () {
                  ToWithFade(context, DetailsShopScreen(
                    userId: shop.userId.toString(),
                  ));
                },
                title: "زيارة السوق",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
