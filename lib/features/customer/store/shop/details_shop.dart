// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/conversation/chat_screen.dart';
import 'package:sheep/managment/shop/customer/shop_customer_cubit.dart';
import 'package:sheep/managment/shop/customer/shop_customer_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/features/customer/store/shop/widget/data_store_widget.dart';
import 'package:sheep/features/customer/store/shop/widget/header_image_shop.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class DetailsShopScreen extends StatefulWidget {
  final String userId;

  const DetailsShopScreen({super.key, required this.userId});

  @override
  State<DetailsShopScreen> createState() => _DetailsShopScreenState();
}

class _DetailsShopScreenState extends State<DetailsShopScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ShopCustomerCubit>().fetchShopDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCustomerCubit, ShopCustomerState>(
      builder: (context, state) {
        if (state.detailsStatus == RequestStatus.loading) {
          return const ShopDetailsShimmer();
        }

        if (state.detailsStatus == RequestStatus.failure) {
          return AppErrorWidget(
            onRetry: () {
              context.read<ShopCustomerCubit>().fetchShopDetails(widget.userId);
            },
            title: state.detailsError,
          );
        }

        final shop = state.shopDetails?.data;

        if (shop == null) {
          return AppErrorWidget(
            onRetry: () {
              context.read<ShopCustomerCubit>().fetchShopDetails(widget.userId);
            },
            title: 'تعذر تحميل تفاصيل المتجر',
          );
        }

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  HeaderShopImage(
                    coverImage: shop.image,
                    logoImage: shop.image,
                    storeName: shop.fullName ?? "اسم البائع",
                  ),

                  SizedBox(height: hi * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _button(AppAssets.report, "", const Color(0xff223B50)),

                      const SizedBox(width: 8),
                      _button(
                        AppAssets.chat,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChatScreen(
                                    sellerId: shop.seller_Id,
                                    entryType: ChatEntryType.fromProduct,
                                    sellerName: shop.fullName ?? "",
                                  ),
                            ),
                          );
                        },
                        "مراسلة",
                        AppColors.primary,
                      ),
                    ],
                  ),

                  SizedBox(height: hi * 0.03),

                  dataStore(
                    location: shop.storeAddress ?? "الرياض، السعودية",
                    name: shop.storeName ?? "اسم المتجر",
                    phone: shop.phone ?? "+966500000000",
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            "المزادات",
                            "${shop.openAuctions ?? 0}",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            "منتجات",
                            "${shop.productsCount ?? 0}",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard("بث مباشر", "${shop.allLives ?? 0}"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tab("المزادات (${shop.openAuctions ?? 0})", true),
                      const SizedBox(width: 10),
                      _tab("المنتجات (${shop.productsCount ?? 0})", false),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _button(String icon, String text, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(22),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(icon, color: color),
            if (text.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(text, style: TextStyle(color: color)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffFFF2CC) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffD4A017)),
      ),
      child: Text(title),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xffE9EDF1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }
}

class ShopDetailsShimmer extends StatelessWidget {
  const ShopDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget shimmerBox({double? height, double? width, BorderRadius? radius}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: radius ?? BorderRadius.circular(12),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              shimmerBox(
                height: hi * 0.25,
                width: double.infinity,
                radius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              SizedBox(height: hi * 0.02),
              shimmerBox(height: 20, width: 150),
              SizedBox(height: hi * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  shimmerBox(height: 38, width: 52),
                  const SizedBox(width: 8),
                  shimmerBox(height: 38, width: 90),
                  const SizedBox(width: 8),
                  shimmerBox(height: 38, width: 90),
                ],
              ),
              SizedBox(height: hi * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: shimmerBox(height: 85)),
                    const SizedBox(width: 10),
                    Expanded(child: shimmerBox(height: 85)),
                    const SizedBox(width: 10),
                    Expanded(child: shimmerBox(height: 85)),
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
