import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/seller/product/root_form_product_screen.dart';

Widget headerTitleManage(BuildContext context){
 return  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "إدارة المنتجات",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff363D4E),
                ),
                GestureDetector(
                  onTap: () {
                    ToWithFade(context, ProductFormScreen.create());
                  },
                  child: Container(
                    height: 40,
                   
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(AppAssets.add, color: AppColors.primary),
                          SizedBox(width: 5,),
                          CustomText(text: "إضافة منتج", color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
}