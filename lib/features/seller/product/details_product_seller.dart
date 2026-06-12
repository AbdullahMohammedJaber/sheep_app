// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/seller/product/widget/menue_widget.dart';
import 'package:sheep/features/seller/product/widget/shimmer_details_product.dart';
import 'package:sheep/features/seller/product/widget/show_image_list.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/home/seller/home_seller_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/customer/auction/widget/description_section.dart';
import 'package:sheep/features/customer/auction/widget/title_section.dart';
import 'package:sheep/features/customer/store/product/widget/analyze_product.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class DetailsProductSeller extends StatefulWidget {
  final dynamic id;
  const DetailsProductSeller({super.key, required this.id});

  @override
  State<DetailsProductSeller> createState() => _DetailsProductSellerState();
}

class _DetailsProductSellerState extends State<DetailsProductSeller> {
  final GlobalKey menuKey = GlobalKey();
  @override
  void initState() {
    context.read<HomeSellerCubit>().detailsProduct(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSellerCubit, HomeSellerState>(
      builder: (context, state) {
        if (state.detailsProductStatus == RequestStatus.loading) {
          return ProductDetailsShimmer();
        } else if (state.detailsProductStatus == RequestStatus.failure) {
          return AppErrorWidget(
            onRetry: () {
              context.read<HomeSellerCubit>().detailsProduct(widget.id);
            },
            title: state.error,
          );
        }
        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: hi * 0.3,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,

                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: 0.0,
                  child: CustomText(
                    text: state.detailsProduct!.data!.name!,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                actions: [
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.arrowLeft,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    key: menuKey,
                    onTap: () => showProductMenu(context, menuKey, state.detailsProduct!.data!),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.more,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: ProductImagesSlider(
                    images:
                        state.detailsProduct!.data!.images!
                            .map(
                              (element) =>
                                  AppAssets.parseImageUrl(element.imageName!),
                            )
                            .toList(),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildContent(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(HomeSellerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: hi * 0.02),
          buildTitleRow(
            address: state.detailsProduct!.data!.address!, 
            name: state.detailsProduct!.data!.name!
          ),
          SizedBox(height: hi * 0.02),
          buildDescription(des:state.detailsProduct!.data!.description! ),
          SizedBox(height: hi * 0.02),
          anlayzeProductSeller(state),
          SizedBox(height: hi * 0.05),
        ],
      ),
    );
  }
}
