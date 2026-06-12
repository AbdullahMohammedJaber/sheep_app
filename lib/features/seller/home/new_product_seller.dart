import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/features/items/shimmer/product_shimmer_list.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/home/seller/home_seller_state.dart';
import 'package:sheep/managment/root/root_cubit.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/items/product_item_seller.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class NewProductSeller extends StatefulWidget {
  const NewProductSeller({super.key});

  @override
  State<NewProductSeller> createState() => _NewProductSellerState();
}

class _NewProductSellerState extends State<NewProductSeller> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<HomeSellerCubit>();

    cubit.fetchMyProducts(refresh: true);

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        cubit.fetchMyProducts();
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
        /// ================= HEADER =================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "أحدث منتجاتك",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff363D4E),
              ),
              GestureDetector(
                onTap: () {
                  context.read<RootCubit>().onClickBottomIconSeller(1);
                },
                child: Row(
                  children: [
                    const CustomText(
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

        BlocBuilder<HomeSellerCubit, HomeSellerState>(
          builder: (context, state) {
            if (state.productStatus == RequestStatus.loading) {
              return const ProductsShimmerList();
            }

            if (state.productStatus == RequestStatus.failure) {
              return AppErrorWidget(
                onRetry: () {
                  context.read<HomeSellerCubit>().fetchMyProducts(
                    refresh: true,
                  );
                },
                title: AppStrings.error_try,
              );
            }
            if (state.products.isEmpty) {
              return Center(child: CustomText(text: AppStrings.noDataProduct));
            }

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...state.products.map((product) {
                        return ProductItemSeller(productSeller: product);
                      }),
                      if (state.productHasMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
