// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/features/customer/auction/widget/accept_reject_auction.dart';
import 'package:sheep/features/seller/product/widget/show_image_list.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

Widget buildSliverAppBar(
  BuildContext context, {
  required bool isCollapsed,
  required DetailsAuctionsResponse details,
  required AuctionsCustomerState state,
  required bool isSeller,
}) {
  return SliverAppBar(
    expandedHeight: hi * 0.4,
    pinned: true,
    stretch: true,
    backgroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,

    title: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isCollapsed ? 1.0 : 0.0,
      child: CustomText(
        text: details.data!.title!,
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
    height: 44,
    width: 44,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.35),
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: SvgPicture.asset(
        AppAssets.arrowLeft,
        color: Colors.white,
        width: 20,
        height: 20,
      ),
    ),
  ),
),
      const Spacer(),
      // Container(
      //   height: 30,
      //   width: 80,
      //   decoration: BoxDecoration(
      //     color: AppColors.error.withOpacity(0.9),
      //     borderRadius: const BorderRadius.only(
      //       bottomLeft: Radius.circular(12),
      //       topRight: Radius.circular(12),
      //     ),
      //   ),
      //   child: const Center(
      //     child: CustomText(
      //       text: "مزاد مباشر",
      //       fontSize: 14,
      //       fontWeight: FontWeight.w600,
      //       color: AppColors.white,
      //     ),
      //   ),
      // ),
      const SizedBox(width: 12),
    ],

    flexibleSpace: FlexibleSpaceBar(
      stretchModes: const [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
      ],
      background: Container(
        color: Colors.grey.shade300,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ProductImagesSlider(
              images:
                  details.data!.images!
                      .map(
                        (element) =>
                            AppAssets.parseImageAuctionUrl(element.imageName!),
                      )
                      .toList(),
            ),
            if (isSeller)
              if (state.realtimeBids.isNotEmpty)
                SellerAuctionDecisionBox(
                  state: state,
                  onAccept: () async {
                    context.read<AuctionCustomerCubit>().acceptAuction(
                      auctionId: details.data!.id,
                    );
                  },
                )
              else
                SizedBox()
            else
              AuctionStatusTime(details: details, state: state),
          ],
        ),
      ),
    ),
  );
}

class AuctionStatusTime extends StatefulWidget {
  final DetailsAuctionsResponse details;
  final AuctionsCustomerState state;
  const AuctionStatusTime({
    super.key,
    required this.details,
    required this.state,
  });

  @override
  State<AuctionStatusTime> createState() => _AuctionStatusTimeState();
}

class _AuctionStatusTimeState extends State<AuctionStatusTime> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final end = widget.details.data?.endTime;

    if (end == null) return;

    _calculateTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTime();
    });
  }

  void _calculateTime() {
    final end = widget.details.data?.endTime;
    if (end == null) return;

    final now = DateTime.now();
    final diff = end.difference(now);

    setState(() {
      if (diff.isNegative) {
        _remaining = Duration.zero;
        _isFinished = true;
        _timer?.cancel();
      } else {
        _remaining = diff;
        _isFinished = false;
      }
    });
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');

    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    return "${two(hours)}:${two(minutes)}:${two(seconds)}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: wi,
      margin: const EdgeInsets.only(bottom: 18, left: 12, right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: wi * 0.03),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isFinished) ...[
                  SvgPicture.asset(
                    AppAssets.timer,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: "ينتهي المزاد خلال",
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 10),
                ],

                CustomText(
                  text:
                      _isFinished
                          ? "انتهى المزاد ⏳ بانتظار موافقة البائع على العرض الأعلى"
                          : _format(_remaining),
                  color: AppColors.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.auction,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: "عدد المزايدات",
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: widget.state.realtimeBids.length.toString(),
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
