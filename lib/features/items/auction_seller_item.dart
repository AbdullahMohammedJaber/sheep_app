// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/core/data/response/auction/auction_seller_response.dart';
import 'package:sheep/features/customer/auction/details_acution.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class AuctionSellerItem extends StatefulWidget {
  AuctionSeller auctionSeller;

  AuctionSellerItem({super.key, required this.auctionSeller});

  @override
  State<AuctionSellerItem> createState() => _AuctionSellerItemState();
}

class _AuctionSellerItemState extends State<AuctionSellerItem> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _calculateTime();
    _startTimer();
  }

  void _calculateTime() {
    final end = widget.auctionSeller.endTime;

    if (end == null) {
      if (!mounted) return;
      setState(() {
        _remaining = Duration.zero;
        _isFinished = true;
      });
      _timer?.cancel();
      return;
    }

    final now = DateTime.now();
    final diff = end.difference(now);

    if (!mounted) return;

    setState(() {
      if (diff.isNegative || diff.inSeconds <= 0) {
        _remaining = Duration.zero;
        _isFinished = true;
        _timer?.cancel();
      } else {
        _remaining = diff;
        _isFinished = false;
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTime();
    });
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatShortTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String _formatLongTime(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '$days يوم ${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String _formatRemainingTime(Duration duration) {
    if (duration.inDays >= 1) {
      return _formatLongTime(duration);
    }

    return _formatShortTime(duration);
  }

  double _timerBoxWidth(BuildContext context) {
    if (_isFinished) return 86;
    if (_remaining.inDays >= 1) return MediaQuery.of(context).size.width * 0.42;
    return 96;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToWithFade(
          context,
          AuctionDetailScreen(id: widget.auctionSeller.id, isSeller: true),
        );
      },
      child: Container(
        width: wi * 0.7,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    AppAssets.parseImageAuctionUrl(
                      widget.auctionSeller.imageName ?? '',
                    ),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 38,
                        ),
                      );
                    },
                  ),
                ),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  end: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        constraints: BoxConstraints(
                          minWidth: 86,
                          maxWidth: _timerBoxWidth(context),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isFinished
                              ? Colors.red
                              : AppColors.black.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.timer,
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CustomText(
                                  text: _isFinished
                                      ? 'منتهي'
                                      : _formatRemainingTime(_remaining),
                                  fontSize: _remaining.inDays >= 1 ? 12 : 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: hi * 0.02),
            Row(
              children: [
                SvgPicture.asset(AppAssets.location),
                SizedBox(width: wi * 0.02),
                Expanded(
                  child: CustomText(
                    text: widget.auctionSeller.address ?? 'الكويت',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: hi * 0.02),
            CustomText(
              text: widget.auctionSeller.title ?? '',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: hi * 0.02),
            CustomText(
              text: '${widget.auctionSeller.currentPrice ?? 0} ر.س',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: hi * 0.01),
            Center(
              child: CustomButton(
                onTap: () {
                  ToWithFade(
                    context,
                    AuctionDetailScreen(
                      id: widget.auctionSeller.id,
                      isSeller: true,
                    ),
                  );
                },
                title: 'إدارة للمزاد',
              ),
            ),
            SizedBox(height: hi * 0.01),
          ],
        ),
      ),
    );
  }
}

class AuctionSellerItemShimmer extends StatelessWidget {
  const AuctionSellerItemShimmer({super.key});

  Widget _buildShimmerBox(double height, double width, {double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: wi * 0.7,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(200, double.infinity, radius: 12),
            SizedBox(height: hi * 0.02),
            Row(
              children: [
                _buildShimmerBox(16, 16),
                SizedBox(width: wi * 0.02),
                Expanded(child: _buildShimmerBox(14, double.infinity)),
              ],
            ),
            SizedBox(height: hi * 0.02),
            _buildShimmerBox(18, double.infinity),
            SizedBox(height: hi * 0.02),
            _buildShimmerBox(18, wi * 0.4),
            SizedBox(height: hi * 0.02),
            Center(child: _buildShimmerBox(45, double.infinity, radius: 12)),
          ],
        ),
      ),
    );
  }
}
