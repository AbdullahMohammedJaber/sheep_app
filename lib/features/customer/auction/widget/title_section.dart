import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget  buildTitleRow({
    String ?name ,
    String ?address ,
}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name??"",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(AppAssets.location),
                  const SizedBox(width: 4),
                  CustomText(
                    text: address??"",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff666666),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.share_outlined,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }