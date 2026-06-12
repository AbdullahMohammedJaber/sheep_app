// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Future<void> showDeleteProductDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "",

    barrierColor: Colors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(child: _DeleteAccountDialogContent(onConfirm: onConfirm));
    },
    transitionBuilder: (_, animation, __, child) {
      final scale = Curves.easeOutBack.transform(animation.value);

      return Transform.scale(
        scale: scale,
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _DeleteAccountDialogContent extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteAccountDialogContent({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade700],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            /// Title
            CustomText(
              text: "حذف المنتج",

              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),

            const SizedBox(height: 14),

            /// Message
            CustomText(
              text: "هل أنت متأكد من حذف المنتج",
              textAlign: TextAlign.center,
              fontSize: 14,

              color: Colors.black87,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                      text: "هل أنت متأكد من حذف هذا المنتج؟ لن يظهر المنتج في سوقك بعد الحذف.",

                      fontSize: 11.5,
                      color: Colors.red,

                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: CustomText(text: "إلغاء", color: AppColors.black),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomText(text: "حذف", color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
