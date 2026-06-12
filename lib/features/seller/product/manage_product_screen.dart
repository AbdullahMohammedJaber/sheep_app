import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/features/items/shimmer/product_c_shimmer.dart';
import 'package:sheep/features/seller/product/widget/category_dialog.dart';
import 'package:sheep/features/seller/product/widget/product_category_section.dart';
import 'package:sheep/managment/category/category_cubit.dart';
import 'package:sheep/managment/product/seller/filter_seller_product_cubit.dart';
import 'package:sheep/managment/product/seller/filter_seller_product_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/theme/font_manager.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/util/widgets/grid_view_custom.dart';
import 'package:sheep/features/items/product_item_seller_state.dart';

import 'package:sheep/features/seller/product/widget/header_title_manage.dart';
import 'package:sheep/main.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  ProductFilterSellerCubit get cubit =>
      context.read<ProductFilterSellerCubit>();

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
      body: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= HEADER =================
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: hi * 0.02),
                headerTitleManage(context),
                SizedBox(height: hi * 0.02),

                _buildSearchBar(),
                SizedBox(height: hi * 0.02),

                Divider(thickness: 1, color: AppColors.border),
              ],
            ),
          ),

          /// ================= LIST =================
          BlocBuilder<ProductFilterSellerCubit, ProductFilterSellerState>(
            builder: (context, state) {
              if (state.isLoading) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return const ProductItemShimmer();
                    }, childCount: 10),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 2,
                          height: hi * 0.40,
                        ),
                  ),
                );
              }

              if (state.products.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CustomText(text: AppStrings.noDataProduct),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = state.products[index];
              
                    return ProductItemSellerState(productSeller: item);
                  }, childCount: state.products.length),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 2,
                        height: hi * 0.35,
                      ),
                ),
              );
            },
          ),

          BlocBuilder<ProductFilterSellerCubit, ProductFilterSellerState>(
            builder: (context, state) {
              if (state.isLoadingMore) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return const SliverToBoxAdapter();
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  /// ================= SEARCH =================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: _searchController,
              hint: "ابحث",
              keyboardType: TextInputType.name,
              onChanged: (value) {
                cubit.onSearch(value);
              },
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [SvgPicture.asset(AppAssets.searchNormal)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _buildFilterButton(),
        ],
      ),
    );
  }

  /// ================= FILTER BUTTON =================
  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _openFilter,
      child: Container(
        height: 55,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: SvgPicture.asset(AppAssets.filter)),
      ),
    );
  }

  /// ================= FILTER SHEET =================
  void _openFilter() {
    final minController = TextEditingController();
    final maxController = TextEditingController();

    Category? category;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "فلترة المنتجات",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  /// ================= PRICE FROM =================
                  CustomTextFormField(
                    controller: minController,
                    hint: "السعر من",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 10),

                  /// ================= PRICE TO =================
                  CustomTextFormField(
                    controller: maxController,
                    hint: "السعر الى",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  /// ================= CATEGORY =================
                  ProductCategorySection(
                    selectedCategory: category?.categoryName ?? "",
                    onTap:
                        () => showDialog(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<CategoryCubit>(),
                              child: CategoryDialog(
                                onSelected: (categoryNew) {
                                  setModalState(() {
                                    category = categoryNew;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      /// ================= APPLY =================
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            cubit.applyFilter(
                              minPrice: double.tryParse(minController.text),
                              maxPrice: double.tryParse(maxController.text),
                              categoryId: category?.id,
                            );

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: CustomText(
                            text: "تطبيق",
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ================= CLEAR =================
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              category = null;
                              category?.id = null;
                              minController.clear();
                              maxController.clear();
                            });
                                
                           cubit.clearFilter();
                         Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "إزالة الفلتر",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontConstants.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
