import 'package:flutter/material.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class SellerAuctionDecisionBox extends StatelessWidget {
  final AuctionsCustomerState state;
  final VoidCallback onAccept;
  

  const SellerAuctionDecisionBox({
    super.key,
    required this.state,
    required this.onAccept,
 
  });

  @override
  Widget build(BuildContext context) {
    final lastBid =
        state.realtimeBids.isNotEmpty ? state.realtimeBids.first : null;

    final amount = lastBid?.amount ?? 0;

    return Container(
      height: 100,
      width: wi,
      margin: const EdgeInsets.only(bottom: 18, left: 12, right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "أعلى سعر مزايدة",
                color: AppColors.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: "$amount ريال",
                color: AppColors.success,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(width: wi * 0.05),
          Expanded(
            child: Row(
              children: [
                
                _ActionButton(
                  title: "قبول",
                  icon: Icons.check_rounded,
                  color: AppColors.success,
                  onTap: onAccept,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: title,
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(width: 8),
              Icon(icon, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
