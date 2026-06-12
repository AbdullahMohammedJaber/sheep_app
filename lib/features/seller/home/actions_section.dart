// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
 import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/features/live/root_live_seller.dart';
import 'package:sheep/managment/root/root_cubit.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/seller/auction/auction_form_screen.dart';
import 'package:sheep/features/seller/product/root_form_product_screen.dart';
import 'package:sheep/main.dart';

class QuickActionModel {
  final String title;
  final String icon;
  final VoidCallback onTap;

  QuickActionModel({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class QuickActionButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Ink(
          height: hi * 0.07,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              SizedBox(width: 5),
              Flexible(
                child: CustomText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff223B50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickActionModel(
        title: "إضافة منتج",
        icon: AppAssets.add,
        onTap: () {
          ToWithFade(context, ProductFormScreen.create());
        },
      ),
      if (HelperAuth().getUser()!.data!.role != UserRole.SheepVendor.name)
        QuickActionModel(
          title: "إدارة منتجاتي",
          icon: AppAssets.product,
          onTap: () {
           
            context.read<RootCubit>().onClickBottomIconSeller(1);
          },
        ),
      if (HelperAuth().getUser()!.data!.role == UserRole.SheepVendor.name)
        QuickActionModel(title: "بث مباشر", icon: AppAssets.live, onTap: () {
          ToWithFade(context, SellerLiveFlowPage());
        }),
      if (HelperAuth().getUser()!.data!.role == UserRole.SheepVendor.name)
        QuickActionModel(
          title: "إنشاء مزاد",
          icon: AppAssets.auction,
          onTap: () {
            ToWithFade(context, AuctionFormScreen());
          },
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "إجراءات سريعة",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),

          const SizedBox(height: 16),

          Row(
            children: List.generate(
              actions.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == actions.length - 1 ? 0 : 5,
                  ),
                  child: QuickActionButton(
                    title: actions[index].title,
                    icon: actions[index].icon,
                    onTap: actions[index].onTap,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
