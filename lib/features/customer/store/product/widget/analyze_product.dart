// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/managment/home/seller/home_seller_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget anlayzeProductSeller(HomeSellerState state) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildRowData(
        icon: AppAssets.users,
        title: "تاريخ النشر",
        value: DateFormat(
          "d/MM/yyyy",
        ).format(state.detailsProduct!.data!.createdAt!),
      ),
      _buildRowData(
        icon: AppAssets.hashtag,
        title: "رقم الإعلان",
        value: state.detailsProduct!.data!.adsNumber!,
      ),
      _buildRowData(icon: AppAssets.car, title: "التوصيل", value: "متاح"),
    ],
  );
}

Widget anlayzeProduct(DetailsProductSellerResponse data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildRowData(
        icon: AppAssets.users,
        title: "تاريخ النشر",
        value: DateFormat("d/MM/yyyy").format(data.data!.createdAt!),
      ),
      _buildRowData(
        icon: AppAssets.hashtag,
        title: "رقم الإعلان",
        value: data.data!.adsNumber!,
      ),
      _buildRowData(icon: AppAssets.car, title: "التوصيل", value: "متاح"),
    ],
  );
}

Widget _buildRowData({
  required String title,
  required String value,
  required String icon,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        SvgPicture.asset(icon, color: AppColors.black),
        SizedBox(width: 8),
        CustomText(
          text: title,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        Spacer(),
        CustomText(
          text: value,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xff666666),
        ),
      ],
    ),
  );
}
