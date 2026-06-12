import 'package:flutter/material.dart';

class CategoryOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryOptionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBF0) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFFE7E7E7),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFD4AF37),
              ),
            if (isSelected) const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: const Color(0xFF232323),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}