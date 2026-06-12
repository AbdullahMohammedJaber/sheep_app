import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/customer/store/product/product_details.dart';
import 'package:sheep/features/items/shimmer/product_c_shimmer.dart';
import 'package:sheep/managment/product/customer/filter_customer_product_cubit.dart';
import 'package:sheep/managment/product/customer/filter_customer_product_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/customer/search/item_search.dart';
import 'package:sheep/main.dart';

class SearchScreenCustomer extends StatefulWidget {
  const SearchScreenCustomer({super.key});

  @override
  State<SearchScreenCustomer> createState() => _SearchScreenCustomerState();
}

class _SearchScreenCustomerState extends State<SearchScreenCustomer> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  ProductFilterCustomerCubit get cubit =>
      context.read<ProductFilterCustomerCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.fetchProducts(refresh: true);
    });

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      cubit.fetchProducts();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: hi * 0.04),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hint: "ابحث عن غنم أو إكسسوارات",
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (p0) {
                      cubit.onSearch(p0);
                    },
                    textInputAction: TextInputAction.search,
                    controller: _searchController,
                    onChanged: (value) {
                      cubit.onSearch(value);
                    },

                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cubit.onSearch(_searchController.text);
                            },

                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(AppAssets.searchNormal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                // GestureDetector(
                //   onTap: () {
                //     showFilterBottomSheet(context);
                //   },
                //   child: Container(
                //     height: 55,
                //     width: 50,
                //     decoration: BoxDecoration(
                //       color: AppColors.primary,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Center(child: SvgPicture.asset(AppAssets.filter)),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: hi * 0.03),
            Row(children: [CustomText(text: "نتائج البحث")]),
            SizedBox(height: hi * 0.02),
            Expanded(
              child: BlocBuilder<
                ProductFilterCustomerCubit,
                ProductFilterCustomerState
              >(
                builder: (context, state) {
                  if (state.isLoading) {
                    return ListView.builder(
                      itemCount: 10,
                      padding: const EdgeInsets.only(top: 12, bottom: 20),
                      itemBuilder: (_, __) => const ProductItemShimmer(),
                    );
                  }

                  if (state.products.isEmpty) {
                    return const Center(
                      child: CustomText(text: AppStrings.noDataProduct),
                    );
                  }

                  return ListView.builder(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(top: 12, bottom: 20),

                    itemCount:
                        state.products.length + (state.isLoadingMore ? 1 : 0),

                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = state.products[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ProductSearchItem(
                          title: item.name ?? '',
                          price: item.fixedPrice?.toString() ?? '',
                          location: item.address ?? '',
                          imageUrl: item.imageName ?? '',
                          onTap: () {
                            ToWithFade(
                              context,
                              ProductDetailsScreen(id: item.id),
                            );
                          },
                          onDetailsTap: () {
                            ToWithFade(
                              context,
                              ProductDetailsScreen(id: item.id),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
