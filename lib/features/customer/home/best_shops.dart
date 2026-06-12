import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/features/items/shimmer/shop_shimmer_list.dart';
import 'package:sheep/managment/shop/customer/shop_customer_cubit.dart';
import 'package:sheep/managment/shop/customer/shop_customer_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/customer/store/shop/all_shops.dart';
import 'package:sheep/features/items/shop_item.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class BestShops extends StatefulWidget {
  const BestShops({super.key});

  @override
  State<BestShops> createState() => _BestShopsState();
}

class _BestShopsState extends State<BestShops> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<ShopCustomerCubit>();

    cubit.fetchShops(refresh: true);

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        cubit.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "أسواق مميزة",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff363D4E),
              ),

              GestureDetector(
                onTap: () {
                  ToWithFade(context, AllShopsScreen());
                },
                child: Row(
                  children: [
                    CustomText(
                      text: "عرض الكل",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(child: SvgPicture.asset(AppAssets.go)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: hi * 0.02),
        BlocBuilder<ShopCustomerCubit, ShopCustomerState>(
          builder: (context, state) {
            if (state.status == RequestStatus.loading) {
              return ShopsShimmerList();
            }
            if (state.status == RequestStatus.failure) {
              return AppErrorWidget(
                onRetry: () {
                  context.read<ShopCustomerCubit>().fetchShops(refresh: true);
                },
                title: AppStrings.error_try,
              );
            }
            if (state.shops.isEmpty) {
              return CustomText(text: AppStrings.noDataShops);
            }
            return SizedBox(
              width: double.infinity,
              height: hi * 0.43,
              child: RefreshIndicator(
                onRefresh:
                    () => context.read<ShopCustomerCubit>().fetchShops(
                      refresh: true,
                    ),
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsetsDirectional.only(start: 12),

                  physics: const BouncingScrollPhysics(),
                  itemCount: state.shops.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.shops.length) {
                      final shop = state.shops[index];

                      return ShopItem(shop: shop);
                    }

          
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
