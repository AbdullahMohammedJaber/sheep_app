// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class ChatAuctionWidget extends StatefulWidget {
  final int auctionId;
  final List<AuctionBid> bids;
  final bool isSeller;
  const ChatAuctionWidget({
    super.key,
    required this.auctionId,
    required this.bids,
    required this.isSeller,
  });

  @override
  State<ChatAuctionWidget> createState() => _ChatAuctionWidgetState();
}

class _ChatAuctionWidgetState extends State<ChatAuctionWidget> {
  late final TextEditingController _bidController;

  double? _lastAnimatedAmount;
  DateTime? _lastAnimatedTime;

  @override
  void initState() {
    super.initState();
    _bidController = TextEditingController();
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  void _submitBid(AuctionsCustomerState state) {
    if (!state.canPlaceBid) return;

    final raw = _bidController.text.trim();
    if (raw.isEmpty) return;

    final amount = double.tryParse(raw);
    if (amount == null) return;

    context.read<AuctionCustomerCubit>().placeBid(
      auctionId: widget.auctionId,
      amount: amount,
    );

    _bidController.clear();
  }

  String _statusLabel(BuyerAuctionRealtimeStatus status) {
    switch (status) {
      case BuyerAuctionRealtimeStatus.initial:
        return 'جاري تهيئة المزاد';
      case BuyerAuctionRealtimeStatus.active:
        return 'المزاد نشط الآن';
      case BuyerAuctionRealtimeStatus.ended:
        return 'انتهى المزاد';
      case BuyerAuctionRealtimeStatus.stopped:
        return 'تم إيقاف المزاد';
    }
  }

  String _formatBidTime(DateTime? time) {
    if (time == null) return "منذ قليل";

    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return "الآن";
    if (diff.inMinutes < 60) return "منذ ${diff.inMinutes} دقيقة";
    if (diff.inHours < 24) return "منذ ${diff.inHours} ساعة";

    return "${time.day}/${time.month}/${time.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCustomerCubit, AuctionsCustomerState>(
      builder: (context, state) {
        final List<AuctionBid> displayBids = widget.bids;

        final bool isAuctionEnded =
            state.buyerAuctionStatus == BuyerAuctionRealtimeStatus.ended;

        final bool isAuctionStopped =
            state.buyerAuctionStatus == BuyerAuctionRealtimeStatus.stopped;

        final bool isThisAuctionActive =
            state.activeAuctionId == widget.auctionId;

        final bool shouldHideInput =
            isThisAuctionActive && (isAuctionEnded || isAuctionStopped);

        final bool canBid =
            state.canPlaceBid &&
            !isAuctionEnded &&
            !isAuctionStopped &&
            isThisAuctionActive;

        final AuctionBid? latestBid =
            displayBids.isNotEmpty ? displayBids.first : null;

        final bool shouldAnimateLatest =
            latestBid != null &&
            (latestBid.amount?.toDouble() != _lastAnimatedAmount ||
                latestBid.createdAt != _lastAnimatedTime);

        if (latestBid != null) {
          _lastAnimatedAmount = latestBid.amount?.toDouble();
          _lastAnimatedTime = latestBid.createdAt;
        }

        return Container(
          height: hi * 0.45,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: const Color(0xffF9FAFA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (state.auctionHubStatus == AuctionHubStatus.connecting &&
                  isThisAuctionActive)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF4E5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffF6C67A)),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomText(
                          text: "جاري الاتصال بغرفة المزايدة...",
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              if (state.shouldShowRetryAuctionConnection && isThisAuctionActive)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF4E5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffF6C67A)),
                  ),
                  child: Column(
                    children: [
                      const CustomText(
                        text: "تعذر الاتصال بغرفة المزايدة",
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<AuctionCustomerCubit>()
                              .retryJoinAuction();
                        },
                        child: Container(
                          height: 40,
                          width: 185,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: "إعادة محاولة الاتصال",
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isAuctionEnded && isThisAuctionActive)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF2EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomText(
                      text: _statusLabel(state.buyerAuctionStatus),
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
              if (isAuctionStopped && isThisAuctionActive)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFDECEC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomText(
                      text: _statusLabel(state.buyerAuctionStatus),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffD32F2F),
                    ),
                  ),
                ),
              Expanded(
                child:
                    displayBids.isEmpty
                        ? const Center(
                          child: CustomText(text: "لا يوجد مزايدات"),
                        )
                        : ListView.separated(
                          reverse: true,
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          itemCount: displayBids.length,
                          itemBuilder: (context, index) {
                            final bid = displayBids[index];
                            final bool isLatestItem = index == 0;

                            return _AuctionBidItem(
                              bid: bid,
                              timeText: _formatBidTime(bid.createdAt),
                              animateHighlight:
                                  isLatestItem && shouldAnimateLatest,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: hi * 0.02);
                          },
                        ),
              ),
              if (!shouldHideInput && !widget.isSeller) ...[
                SizedBox(height: hi * 0.02),
                Container(
                  height: hi * 0.08,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: !canBid || state.isPlacingBid,
                          child: Opacity(
                            opacity: canBid ? 1 : 0.55,
                            child: CustomTextFormField(
                              controller: _bidController,
                              keyboardType: TextInputType.number,
                              hint:
                                  canBid
                                      ? "أدخل مزايدتك"
                                      : "انتظر الاتصال بغرفة المزايدة",
                              borderRadius: 10,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap:
                            canBid && !state.isPlacingBid
                                ? () => _submitBid(state)
                                : null,
                        child: Opacity(
                          opacity: canBid ? 1 : 0.5,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child:
                                  state.isPlacingBid
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const CustomText(
                                        text: "زايد",
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _AuctionBidItem extends StatefulWidget {
  final AuctionBid bid;
  final String timeText;
  final bool animateHighlight;

  const _AuctionBidItem({
    required this.bid,
    required this.timeText,
    required this.animateHighlight,
  });

  @override
  State<_AuctionBidItem> createState() => _AuctionBidItemState();
}

class _AuctionBidItemState extends State<_AuctionBidItem> {
  bool _highlight = false;

  @override
  void initState() {
    super.initState();
    _runHighlightIfNeeded();
  }

  @override
  void didUpdateWidget(covariant _AuctionBidItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateHighlight &&
        (oldWidget.bid.amount != widget.bid.amount ||
            oldWidget.bid.createdAt != widget.bid.createdAt)) {
      _runHighlightIfNeeded();
    }
  }

  void _runHighlightIfNeeded() {
    if (!widget.animateHighlight) return;

    setState(() => _highlight = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _highlight = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: hi * 0.08,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _highlight ? const Color(0xffFFF8E6) : AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border:
            _highlight
                ? Border.all(color: const Color(0xffF4C95D), width: 1)
                : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.bid.customerName ?? "مزايد",
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: hi * 0.01),
                CustomText(
                  text: widget.timeText,
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          CustomText(
            text: "${widget.bid.amount ?? 0} ريال",
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
