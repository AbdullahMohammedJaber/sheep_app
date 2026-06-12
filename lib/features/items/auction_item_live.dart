// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sheep/core/data/response/live/all_live_response.dart';
import 'package:sheep/features/live/live_customer_screen.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

class AuctionItemLive extends StatefulWidget {
  final LiveResponseItem auctionCustomer;

  const AuctionItemLive({super.key, required this.auctionCustomer});

  @override
  State<AuctionItemLive> createState() => _AuctionItemLiveState();
}

class _AuctionItemLiveState extends State<AuctionItemLive> {
  Duration remaining = Duration.zero;
  Timer? timer;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final startedAt = widget.auctionCustomer.startedAt;

    if (startedAt == null) {
      remaining = Duration.zero;
      isFinished = true;
      return;
    }

    final endTime = startedAt.add(const Duration(hours: 1));

    void updateRemaining() {
      final diff = endTime.difference(DateTime.now());

      if (diff.inSeconds <= 0) {
        timer?.cancel();
        if (!mounted) return;

        setState(() {
          remaining = Duration.zero;
          isFinished = true;
        });
      } else {
        if (!mounted) return;

        setState(() {
          remaining = diff;
          isFinished = false;
        });
      }
    }

    updateRemaining();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateRemaining();
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _openDetails() {
    final id = widget.auctionCustomer.id;
    if (id == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => LiveCustomerScreen(
              id: id.toString(),
              channelName: widget.auctionCustomer.channelName!,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.auctionCustomer;

    return GestureDetector(
      onTap: _openDetails,
      child: Container(
        width: wi * 0.7,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: hi * 0.22,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.live_tv_rounded,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),

                  // Positioned(
                  //   top: 10,
                  //   right: 10,
                  //   child: Container(
                  //     height: 30,
                  //     padding: const EdgeInsets.symmetric(horizontal: 8),
                  //     decoration: BoxDecoration(
                  //       color: isFinished
                  //           ? Colors.red
                  //           : AppColors.black.withOpacity(0.7),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         SvgPicture.asset(
                  //           AppAssets.timer,
                  //           color: Colors.white,
                  //           width: 16,
                  //           height: 16,
                  //         ),
                  //         const SizedBox(width: 5),
                  //         CustomText(
                  //           text: isFinished ? "منتهي" : formatDuration(remaining),
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w700,
                  //           color: Colors.white,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            SizedBox(height: hi * 0.01),

            CustomText(
              text: item.liveName ?? '',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: hi * 0.01),

            CustomText(
              text: item.liveDescription ?? '',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            SizedBox(height: hi * 0.01),

            Center(
              child: CustomButton(onTap: _openDetails, title: "الدخول للبث"),
            ),

             
          ],
        ),
      ),
    );
  }
}
