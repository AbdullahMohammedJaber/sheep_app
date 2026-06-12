// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/core/server/servise.dart';
import 'package:sheep/features/customer/auction/widget/anlayze_auction.dart';
import 'package:sheep/features/customer/auction/widget/chat_auction.dart';
import 'package:sheep/features/customer/auction/widget/description_section.dart';
import 'package:sheep/features/customer/auction/widget/history_auction.dart';
import 'package:sheep/features/customer/auction/widget/owner_section.dart';
import 'package:sheep/features/customer/auction/widget/sliver_app_bar.dart';
import 'package:sheep/features/customer/auction/widget/title_section.dart';
import 'package:sheep/features/seller/product/widget/shimmer_details_product.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class AuctionDetailScreen extends StatefulWidget {
  final dynamic id;
  final bool isSeller;
  const AuctionDetailScreen({
    super.key,
    required this.id,
    required this.isSeller,
  });

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  bool _isCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  int get _auctionId => int.tryParse(widget.id.toString()) ?? 0;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<AuctionCustomerCubit>();
    cubit.fetchAuctionDetails(widget.id);
    cubit.joinAuction(
      auctionId: _auctionId,
      hubBaseUrl: ApiService.url,
      accessToken: HelperAuth().getUser()!.data!.accessToken,
    );

    _scrollController.addListener(() {
      final collapsed = _scrollController.offset > hi * 0.35;
      if (collapsed != _isCollapsed) {
        setState(() => _isCollapsed = collapsed);
      }
    });
  }

  @override
  void dispose() {
    context.read<AuctionCustomerCubit>().leaveCurrentAuction();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCustomerCubit, AuctionsCustomerState>(
      listenWhen:
          (previous, current) =>
              previous.bidError != current.bidError ||
              previous.auctionHubError != current.auctionHubError,
      listener: (context, state) {
        if (state.bidError != null && state.bidError!.isNotEmpty) {
          showMessage(state.bidError!, value: false);

          context.read<AuctionCustomerCubit>().clearBidError();
        }

        if (state.auctionHubError != null &&
            state.auctionHubError!.isNotEmpty) {
          showMessage(state.auctionHubError!, value: false);

          context.read<AuctionCustomerCubit>().clearAuctionHubError();
        }
      },
      builder: (context, state) {
        if (state.isDetailsLoading) {
          return ProductDetailsShimmer();
        } else if (state.detailsError != null) {
          return AppErrorWidget(
            onRetry: () {
              context.read<AuctionCustomerCubit>().fetchAuctionDetails(
                widget.id,
              );
            },
            title: state.detailsError,
          );
        }

        final details = state.detailsAuctionResponse;
        if (details == null || details.data == null) {
          return AppErrorWidget(
            onRetry: () {
              context.read<AuctionCustomerCubit>().fetchAuctionDetails(
                widget.id,
              );
            },
            title: 'تعذر تحميل تفاصيل المزاد',
          );
        }

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              buildSliverAppBar(
                context,
                state: state,
                isCollapsed: _isCollapsed,
                details: details,
                isSeller: widget.isSeller,
              ),
              SliverToBoxAdapter(child: _buildContent(context, details, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    DetailsAuctionsResponse details,
    AuctionsCustomerState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: hi * 0.02),
          buildTitleRow(
            address: details.data!.address ?? "الكويت",
            name: details.data!.title,
          ),
          SizedBox(height: hi * 0.02),
          buildDescription(des: details.data!.description),

          if (!widget.isSeller) ...[
            SizedBox(height: hi * 0.02),

            buildOwnerSection(
              context,
              sellerId: details.data!.sellerId,
              sellerName:
                  details.data!.userName ??
                  details.data!.sellerName ??
                  "غير معروف",
            ),
          ],

          SizedBox(height: hi * 0.03),
          anlayesAuctionSection(
            isSeller: widget.isSeller,
            countBids: state.realtimeBids.length,
            statrtPrice: details.data!.startPrice ?? 0,
            currentPrice:
                state.currentPrice == 0
                    ? (details.data!.currentPrice ?? 0)
                    : state.currentPrice,
          ),
          SizedBox(height: hi * 0.03),
          historyAuction(bids: state.realtimeBids),
          SizedBox(height: hi * 0.03),
          ChatAuctionWidget(
            isSeller: widget.isSeller,
            auctionId: _auctionId,
            bids: state.realtimeBids,
          ),
          SizedBox(height: hi * 0.1),
        ],
      ),
    );
  }
}
