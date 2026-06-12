import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
 class AuctionStatusSelector extends StatelessWidget {
  const AuctionStatusSelector({super.key});

  static const _items = AuctionStatus.values;
  static const _unselectedColor = Color(0xff9E9E9E);
  static const _trackColor = Color(0xffF2F2F2);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCustomerCubit, AuctionsCustomerState>(
      builder: (context, state) {
        return Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _trackColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: _items.map((item) {
              final isSelected = state.selectedStatus == item;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<AuctionCustomerCubit>()
                        .changeStatus(item);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    AppColors.primary.withOpacity(0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : _unselectedColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsetsDirectional.only(end: 5),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          CustomText(text:  item.label),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}