// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/core/data/response/auction/auction_customer_response.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/features/auth/widget/dialog_auth.dart';
import 'package:sheep/features/customer/auction/details_acution.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class AuctionItem extends StatefulWidget {
  final AuctionCustomer auctionCustomer;

  const AuctionItem({super.key, required this.auctionCustomer});

  @override
  State<AuctionItem> createState() => _AuctionItemState();
}

class _AuctionItemState extends State<AuctionItem> {
  Duration remaining = Duration.zero;
  Timer? timer;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();

    if (widget.auctionCustomer.endTime == null) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final endTime = widget.auctionCustomer.endTime;

    if (endTime == null) {
      if (!mounted) return;
      setState(() {
        remaining = Duration.zero;
        isFinished = true;
      });
      timer?.cancel();
      return;
    }

    final now = DateTime.now();
    final diff = endTime.difference(now);

    if (!mounted) return;

    if (diff.isNegative || diff.inSeconds <= 0) {
      timer?.cancel();
      setState(() {
        remaining = Duration.zero;
        isFinished = true;
      });
    } else {
      setState(() {
        remaining = diff;
        isFinished = false;
      });
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (days > 0) {
      return '${days}ي ${_twoDigits(hours)}س ${_twoDigits(minutes)}د ${_twoDigits(seconds)}ث';
    }

    return '${_twoDigits(duration.inHours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  void _openAuctionDetails() {
    ToWithFade(
      context,
      AuctionDetailScreen(
        id: widget.auctionCustomer.id,
        isSeller: false,
      ),
    );
  }

  Widget _buildTimerBadge() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 30,
        maxWidth: wi * 0.55,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isFinished ? Colors.red : AppColors.black.withOpacity(0.72),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.timer,
              color: Colors.white,
              width: 15,
              height: 15,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: isFinished ? 'منتهي' : formatDuration(remaining),
                  fontSize: remaining.inDays > 0 ? 12 : 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AuctionItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.auctionCustomer.endTime != widget.auctionCustomer.endTime) {
      _calculateRemaining();
      _startTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (HelperAuth().getLogin()) {
          _openAuctionDetails();
        } else {
          showLoginRequiredDialog(
            context: context,
            onLogin: () {
              toRemoveAll(LoginScreen());
            },
          );
        }
      },
      child: Container(
        width: wi * 0.7,
        height: hi * 0.52,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    AppAssets.parseImageAuctionUrl(
                      widget.auctionCustomer.imageName ?? '',
                    ),
                    fit: BoxFit.cover,
                    height: hi * 0.25,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: hi * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey.shade500,
                          size: 34,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  left: 10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _buildTimerBadge(),
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
                    text: widget.auctionCustomer.address ?? 'الكويت',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: hi * 0.01),

            CustomText(
              text: widget.auctionCustomer.title ?? '',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: hi * 0.01),

            CustomText(
              text: '${widget.auctionCustomer.currentPrice} ر.س',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            Center(
              child: CustomButton(
                onTap: _openAuctionDetails,
                title: 'الدخول للمزاد',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
