import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sheep/managment/product/customer/product_customer_cubit.dart';
import 'package:sheep/managment/product/customer/product_customer_state.dart';

import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';

import 'package:sheep/features/customer/store/product/all_product_screen.dart';
import 'package:sheep/features/items/product_item.dart';
import 'package:sheep/features/items/shimmer/product_shimmer_list.dart';

import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/widgets/error_screen.dart';
import 'package:sheep/main.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<ProductCustomerCubit>();

    cubit.fetchProducts(refresh: true);

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
              const CustomText(
                text: "أحدث المنتجات",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff363D4E),
              ),

              GestureDetector(
                onTap: () {
                  ToWithFade(context, const AllProductScreen());
                },
                child: Row(
                  children: [
                    const CustomText(
                      text: "عرض الكل",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
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

 
        BlocBuilder<ProductCustomerCubit, ProductCustomerState>(
          builder: (context, state) {
       
            if (state.status == RequestStatus.loading) {
              return const ProductsShimmerList();
            }

         
            if (state.status == RequestStatus.failure) {
              return AppErrorWidget(
                onRetry: () {
                  context.read<ProductCustomerCubit>().fetchProducts(
                    refresh: true,
                  );
                },
                title: AppStrings.error_try,
              );
            }

        
            if (state.products.isEmpty) {
              return CustomText(text: AppStrings.noDataProduct);
            }

       
            return SizedBox(
              width: double.infinity,
              height: hi * 0.49,
              child: RefreshIndicator(
                onRefresh:
                    () => context.read<ProductCustomerCubit>().fetchProducts(
                      refresh: true,
                    ),
                child: ListView.builder(
                  controller: _controller,
                  padding: EdgeInsetsDirectional.only(start: 12),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.products.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                  
                    if (index < state.products.length) {
                    final product = state.products[index];

                      return ProductItem(
                        productCustomer: product,
                       );
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
