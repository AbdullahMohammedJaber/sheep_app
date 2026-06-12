import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class ProductStatusSelector extends StatefulWidget {
  final Function(String) onChanged;

  const ProductStatusSelector({super.key, required this.onChanged});

  @override
  State<ProductStatusSelector> createState() => _ProductStatusSelectorState();
}

class _ProductStatusSelectorState extends State<ProductStatusSelector> {
  String _selected = "الكل";

  static const _items = ["الكل", "حلاقة", "بيطرة", "ملحمة"];

  static const _unselectedColor = Color(0xff9E9E9E);
  static const _trackColor = Color(0xffF2F2F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _items.map((item) => _buildTab(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String item) {
    final bool isSelected = _selected == item;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          if (_selected == item) return;
          setState(() => _selected = item);
          widget.onChanged(item);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.18),
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
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : _unselectedColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsetsDirectional.only(end: 5),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                CustomText(text: item)
              ],
            ),
          ),
        ),
      ),
    );
  }
}