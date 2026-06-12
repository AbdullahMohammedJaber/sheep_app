// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sheep/managment/auction/seller/filter_seller_auction_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/managment/auction/seller/filter_seller_auction_cubit.dart';
 

class AuctionStatusSellerSelector extends StatelessWidget {
  final Function(AuctionStatus) onChanged;

  const AuctionStatusSellerSelector({
    super.key,
    required this.onChanged,
  });

  final Map<AuctionStatus, String> labels = const {
    AuctionStatus.all: "الكل",
    AuctionStatus.active: "نشط الان",
    AuctionStatus.ended: "منتهي",
  };

  static const _unselectedColor = Color(0xff9E9E9E);
  static const _trackColor = Color(0xffF2F2F2);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionFilterSellerCubit,
        AuctionFilterSellerState>(
      builder: (context, state) {
        return Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _trackColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: AuctionStatus.values
                .map((status) => _buildTab(
                      context,
                      status,
                      state.status,
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context,
    AuctionStatus status,
    AuctionStatus selected,
  ) {
    final bool isSelected = selected == status;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isSelected) return;

          onChanged(status);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
             color: isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? AppColors.primary
                  : _unselectedColor,
            ),
            child: CustomText(text: labels[status]!),
          ),
        ),
      ),
    );
  }
}