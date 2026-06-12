import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/managment/auction/seller/filter_seller_auction_cubit.dart';
import 'package:sheep/managment/auction/seller/filter_seller_auction_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/features/items/auction_seller_item.dart';
import 'package:sheep/features/seller/auction/widget/header_title_auction_manage.dart';
import 'package:sheep/features/seller/auction/widget/status_auction_seller.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class ManageAcutionScreen extends StatefulWidget {
  const ManageAcutionScreen({super.key});

  @override
  State<ManageAcutionScreen> createState() => _ManageAcutionScreenState();
}

class _ManageAcutionScreenState extends State<ManageAcutionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuctionFilterSellerCubit>().fetchAuctions(refresh: true);
    });
  }

  Future<void> _onRefresh() async {
    await context.read<AuctionFilterSellerCubit>().fetchAuctions(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            /// HEADER
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: hi * 0.02),
                  headerTitleAuctionManage(context),
                  SizedBox(height: hi * 0.02),
                  _buildSearchBar(context),
                  SizedBox(height: hi * 0.02),
                  Divider(thickness: 1, color: AppColors.border),
                ],
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _StatusSelectorDelegate(
                child: AuctionStatusSellerSelector(
                  onChanged: (status) {
                    context.read<AuctionFilterSellerCubit>().applyFilter(
                      status: status,
                    );
                  },
                ),
              ),
            ),

            BlocBuilder<AuctionFilterSellerCubit, AuctionFilterSellerState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: AuctionSellerItemShimmer(),
                      );
                    }, childCount: 6),
                  );
                }

                if (state.error != null) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: AppErrorWidget(
                        onRetry: () {
                          context
                              .read<AuctionFilterSellerCubit>()
                              .fetchAuctions(refresh: true);
                        },
                        title: state.error,
                      ),
                    ),
                  );
                }

                if (state.auctions.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CustomText(text: AppStrings.noDataAuction),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == state.auctions.length - 1) {
                        context
                            .read<AuctionFilterSellerCubit>()
                            .fetchAuctions();
                      }

                      final auction = state.auctions[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: AuctionSellerItem(
                          auctionSeller: auction,
                        ),
                      );
                    }, childCount: state.auctions.length),
                  ),
                );
              },
            ),

            /// LOAD MORE
            BlocBuilder<AuctionFilterSellerCubit, AuctionFilterSellerState>(
              builder: (context, state) {
                if (!state.isLoadingMore) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }

                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  /// SEARCH
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hint: "ابحث",
              onChanged: (value) {
                context.read<AuctionFilterSellerCubit>().onSearch(value);
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
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // showAuctionFilterSheet(context);
      },
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
}

class _StatusSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _StatusSelectorDelegate({required this.child});
  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StatusSelectorDelegate oldDelegate) {
    return false;
  }
}
