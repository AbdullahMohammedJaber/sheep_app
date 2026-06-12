import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/features/customer/auction/widget/description_section.dart';
import 'package:sheep/features/customer/auction/widget/owner_section.dart';
import 'package:sheep/features/customer/auction/widget/title_section.dart';
import 'package:sheep/features/customer/store/product/widget/analyze_product.dart';
import 'package:sheep/features/customer/store/product/widget/sliver_appbar_product.dart';
import 'package:sheep/features/seller/product/widget/shimmer_details_product.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/home/seller/home_seller_state.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic id;
  const ProductDetailsScreen({super.key, required this.id});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<HomeSellerCubit>().detailsProduct(widget.id);
    super.initState();
    _scrollController.addListener(() {
      final collapsed = _scrollController.offset > hi * 0.35;
      if (collapsed != _isCollapsed) {
        setState(() => _isCollapsed = collapsed);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              buildSliverAppBarProduct(
                context,
                isCollapsed: _isCollapsed,
                data: state.detailsProduct!,
              ),
              SliverToBoxAdapter(child: _buildContent(state.detailsProduct!)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(DetailsProductSellerResponse data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: hi * 0.02),
          buildTitleRow(address: data.data!.address!, name: data.data!.name!),
          SizedBox(height: hi * 0.02),
          buildDescription(des: data.data!.description),
          SizedBox(height: hi * 0.02),
          buildOwnerSection(
            context,
            sellerId: data.data!.sellerId,
            sellerName: data.data!.sellerName,
          ),
          SizedBox(height: hi * 0.03),
          anlayzeProduct(data),
          SizedBox(height: hi * 0.05),
        ],
      ),
    );
  }
}
