import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class ProductActionsSection extends StatelessWidget {
  final String submitText;
  final bool isLoading;
  final Color submitButtonColor;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const ProductActionsSection({
    super.key,
    required this.submitText,
    required this.isLoading,
    required this.submitButtonColor,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: submitButtonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                disabledBackgroundColor: submitButtonColor.withOpacity(.65),
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : CustomText(
                        text: submitText,
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
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
                disabledForegroundColor: const Color(
                  0xFF29415B,
                ).withOpacity(.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: CustomText(
                text: 'إلغاء',

                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF29415B),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
