// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/features/items/shimmer/auction_shimmer_list.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/customer/auction/widget/status_search_auction.dart';
import 'package:sheep/features/items/auction_items.dart';
import 'package:sheep/main.dart';

class AllAuctionsScreen extends StatefulWidget {
  const AllAuctionsScreen({super.key});

  @override
  State<AllAuctionsScreen> createState() => _AllAuctionsScreenState();
}

class _AllAuctionsScreenState extends State<AllAuctionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<AuctionCustomerCubit>();

    cubit.fetchAuctions(refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.loadMore();
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
    return BlocConsumer<AuctionCustomerCubit, AuctionsCustomerState>(
      listener: (context, state) {},

      builder: (context, state) {
        final cubit = context.read<AuctionCustomerCubit>();

        final isLoading = state.isLoading;
        final auctions = state.auctions;

        return Scaffold(
          appBar: AppBar(toolbarHeight: 1),

          body: RefreshIndicator(
            onRefresh: () => cubit.refresh(),

            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: hi * 0.02),

                      CustomText(
                        text: AppStrings.auctions,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),

                      SizedBox(height: hi * 0.02),

                      _buildSearchBar(cubit),

                      SizedBox(height: hi * 0.03),

                      const Divider(thickness: 2, color: AppColors.border),
                    ],
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StatusSelectorDelegate(
                    child: const AuctionStatusSelector(),
                  ),
                ),

                /// LOADING
                if (isLoading)
                  const SliverFillRemaining(
                    child: AuctionsShimmerList(scroll: Axis.vertical),
                  )
                else if (auctions.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: CustomText(
                        text: AppStrings.noDataAuction,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == auctions.length) {
                            if (state.isLoadingMore) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return const SizedBox();
                          }

                          final item = auctions[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: AuctionItem(auctionCustomer: item),
                          );
                        },

                        childCount:
                            state.hasMore
                                ? auctions.length + 1
                                : auctions.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= SEARCH =================
  Widget _buildSearchBar(AuctionCustomerCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
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

          // const SizedBox(width: 10),

          // _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () {
        // future filter sheet
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
