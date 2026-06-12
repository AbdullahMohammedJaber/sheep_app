import 'package:flutter/material.dart';
import 'package:sheep/features/seller/product/widget/section_title.dart';

 
class AuctionDurationSection extends StatelessWidget {
  final List<int> durations;
  final int selectedDuration;
  final ValueChanged<int> onDurationSelected;

  const AuctionDurationSection({
    super.key,
    required this.durations,
    required this.selectedDuration,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    const border = Color(0xFFE7E7E7);
    const textColor = Color(0xFF2A2A2A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('مدة المزاد (دقائق)'),
        const SizedBox(height: 14),
        Row(
          children: durations.map((duration) {
            final selected = duration == selectedDuration;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: duration == durations.last ? 0 : 10,
                ),
                child: GestureDetector(
                  onTap: () => onDurationSelected(duration),
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFFFFBF0)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: selected ? gold : border,
                        width: 1.4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        duration.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? gold : textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}