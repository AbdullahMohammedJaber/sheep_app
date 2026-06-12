import 'package:flutter/material.dart';
import 'package:sheep/util/theme/font_manager.dart';

class AuctionActionsSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const AuctionActionsSection({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    const border = Color(0xFFE7E7E7);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.white,
                elevation: 0,
                disabledBackgroundColor: gold.withOpacity(.65),
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "إنشاء المزاد",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: FontConstants.fontFamily
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 58,
            child: OutlinedButton(
              onPressed: isLoading ? null : onCancel,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: border),
                backgroundColor: Colors.white,
                disabledForegroundColor: const Color(0xFF29415B).withOpacity(.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF29415B),
                  fontFamily: FontConstants.fontFamily
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}